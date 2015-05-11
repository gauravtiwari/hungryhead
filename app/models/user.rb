class User < ActiveRecord::Base

  #External modules
  include ActiveModel::Validations
  include Rails.application.routes.url_helpers
  #redis objects
  include Redis::Objects
  #order objects in same order as given
  extend OrderAsSpecified

  #Concerns for User class
  include Followable
  include Follower
  include Mentionable
  include Sluggable
  include Suggestions
  include Scorable
  include Feedbacker
  include Investor
  include Commenter
  include Voter

  #Tagging System
  acts_as_taggable_on :hobbies, :locations, :subjects, :markets
  acts_as_tagger

  #Sorted set to store followers, followings ids and latest activities
  set :followers_ids
  set :followings_ids
  set :idea_followings_ids
  set :school_followings_ids
  list :latest_ideas, maxlength: 20, marshal: true

  #Sorted set to store popular and latest user
  sorted_set :trending, global: true
  sorted_set :popular, global: true

  #List to store latest users
  list :latest, maxlength: 20, marshal: true, global: true

  #Store latest user notifications
  sorted_set :latest_notifications, maxlength: 100, marshal: true

  #Redis counters to cache total followers, followings,
  #feedbacks, investments and ideas
  counter :followers_counter
  counter :followings_counter
  counter :feedbacks_counter
  counter :investments_counter
  counter :comments_counter
  counter :votes_counter
  counter :ideas_counter
  counter :notes_counter

  #Enumerators to handle states
  enum state: { inactive: 0, published: 1}
  enum role: { user: 0, student: 1, entrepreneur: 2, mentor: 3, teacher: 4 }

  #Accessor methods for JSONB datatypes
  store_accessor :profile, :facebook_url, :twitter_url, :linkedin_url, :website_url
  store_accessor :media, :avatar_position, :cover_position, :cover_left,
  :cover_processing, :avatar_processing
  store_accessor :settings, :theme, :idea_notifications, :note_notifications, :feedback_notifications,
  :investment_notifications, :follow_notifications, :weekly_mail
  store_accessor :fund, :balance, :invested_amount, :earned_amount
  serialize [:fund, :education, :interests, :profile, :settings], HashSerializer

  #Devise for authentication
  devise :invitable, :async, :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :confirmable,
    :registerable, :authentication_keys => [:login]

  attr_accessor :login

  #Model Relationships
  belongs_to :school

  has_many :authentications, :dependent => :destroy
  has_many :activities, :dependent => :destroy
  has_many :notifications, :dependent => :destroy
  has_many :notes, dependent: :destroy

  #Media Uploaders - carrierwave
  mount_uploader :avatar, LogoUploader
  mount_uploader :cover, CoverUploader

  #Scopes for searching
  scope :entrepreneurs, -> { where(role: 1) }
  scope :users, -> { where(role: 0) }

  #Callbacks
  before_save :add_fullname, unless: :name_present?
  before_save :add_username, if: :username_absent?
  before_destroy :remove_from_soulmate, :decrement_counters, :delete_activity, unless: :is_admin
  after_create :seed_fund, :seed_settings, unless: :is_admin
  after_save :load_into_soulmate, :rebuild_notifications, unless: :is_admin
  after_commit :increment_counters, on: :create

  #Model Validations
  validates :email, :presence => true, :uniqueness => {:case_sensitive => false}
  validates :name, :presence => true
  validates :username, :presence => true, :uniqueness => true, format: { with: /\A[a-zA-Z0-9]+\Z/, message: "should not contain empty spaces or symbols" }
  validates :password, :confirmation => true, :presence => true, :length => {:within => 6..40}, :on => :create

  #Get username suggestions
  suggestions_for :username, :num_suggestions => 5,
      :first_name_attribute => :firstname, :last_name_attribute => :lastname

  #Reading models
  acts_as_reader

  #Messaging system
  acts_as_messageable

  #Public methods
  public

  def can_score?
    true
  end

  def mailboxer_email(object)
    email
  end

  def balance_available?(amount)
    balance > amount.to_i
  end

  #Login using both email and username
  def login=(login)
    @login = login
  end

  def login
    @login || self.username || self.email
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later!(wait: 5.seconds)
  end

  def school_name
    school_id.present? ? school.name : ""
  end

  def user_name_badge
    first_name.present? ? first_name.first + last_name.first : add_fullname
  end

  def firstname
    self.name.split(' ').first
  end

  def lastname
    self.name.split(' ').second
  end


  def user_json
    {
      id: id,
      avatar: avatar.url(:avatar),
      name_badge: user_name_badge,
      name: name,
      description: mini_bio,
      url: profile_path(self),
      created_at: "#{created_at.to_formatted_s(:iso8601)}"
    }
  end

  private

  #returns if a user is admin
  def is_admin
    admin?
  end

  def name_present?
    !first_name.present? && !last_name.present?
  end

  def username_absent?
    !username.present?
  end

  def add_username
    email_username = self.name.parameterize
    if User.find_by_username(email_username).blank?
      email_username = email_username
    else
      num = 1
      while(User.find_by_username(email_username).present?)
        email_username = "#{self.name.parameterize}#{num}"
        num += 1
      end
    end
    self.username = email_username
  end

  # returns and adds first_name and last_name to database
  def add_fullname
    self.first_name = firstname
    self.last_name =  lastname
  end

  #Seeds amount into database on: :create
  def seed_fund
    self.fund = {balance: 1000}
  end

  #Seeds settings into database on: :create
  def seed_settings
    self.settings = {
      theme: 'solid',
      idea_notifications: true,
      feedback_notifications: true,
      investment_notifications: true,
      follow_notifications: true,
      note_notifications: true,
      weekly_mail: true
    }
  end

  #Slug attributes for friendly id
  def slug_candidates
    [:username]
  end

  def rebuild_notifications
    if rebuild_cache? && has_notifications?
      unless admin?
        #rebuild user feed every time name and avatar update.
        RebuildNotificationsCacheJob.set(wait: 5.seconds).perform_later(id)
      end
    end
  end

  def rebuild_cache?
    #check if basic info changed and user is not new
    name_changed? || avatar_changed? || username_changed? && !id_changed?
  end

  def has_notifications?
    #check if user has notifications
    latest_notifications.members.length > 0
  end

  #Load data to redis using soulmate after_save
  def load_into_soulmate
    #Seperate index for each user type
    unless admin?
      if type == "Student"
        soulmate_loader("students")
      elsif type == "Mentor"
        soulmate_loader("mentors")
      elsif type == "Teacher"
        soulmate_loader("teachers")
      end
    end
  end

  def soulmate_loader(type)
    #instantiate soulmate loader to re-generate search index
    loader = Soulmate::Loader.new(type)
    loader.add(
      "term" => name,
      "image" => avatar.url(:avatar),
      "description" => mini_bio,
      "id" => id,
      "data" => {
        "link" => profile_path(self)
      }
    )
  end

  def remove_from_soulmate
    #Remove search index if :record destroyed
    loader = Soulmate::Loader.new("students")
    loader.remove("id" => id)
  end

  def increment_counters
    #Increment counters
    school.students_counter.increment if school_id.present? && self.type == "Student"
    #Cache lists for school
    school.latest_students << user_json if school_id.present? && self.type == "Student"
    school.latest_faculties << user_json if school_id.present? && self.type == "Teacher"
    #Cache sorted set for global leaderboard
    User.latest << user_json unless self.type == "User"
    User.popular.add(id, 1) unless self.type == "User"
    User.trending.add(id, 1) unless self.type == "User"
  end

  def decrement_counters
    #Decrement counters
    school.students_counter.decrement if school_id.present && school.students_counter.value > 0 && self.type == "Student"
    #delete cached lists for school
    school.latest_students.delete(user_json) if school_id.present? && self.type == "Student"
    school.latest_faculties.delete(user_json) if school_id.present? && self.type == "Teacher"
    #delete cached sorted set for global leaderboard
    User.latest.delete(id) unless self.type == "User"
    User.popular.delete(id) unless self.type == "User"
    User.trending.delete(id) unless self.type == "User"
  end

  def update_redis_cache
    if rebuild_cache? || mini_bio_changed?
      #get current score
      popular_score = User.popular.score(id)
      trending_score = User.trending.score(id)
      #Delete cache
      User.popular.delete(id)
      User.latest.delete(user_json)
      User.trending.delete(id)
      #Regenerate cache with current score
      User.popular.add(id, popular_score)
      User.trending.add(id, trending_score)
      User.latest << user_json unless type == "User"
      #School list cache
      school.latest_students.delete(user_json) if school && type == "Student"
      school.latest_faculties.delete(user_json) if school && type == "Teacher"
      #Regenerate school list
      school.latest_students << user_json if school && type == "Student"
      school.latest_faculties << user_json if school && type == "Teacher"
    end
  end

  #Deletes all dependent activities for this user
  def delete_activity
    DeleteUserFeedJob.set(wait: 5.seconds).perform_later(self.id, self.class.to_s)
  end

  protected

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

end
