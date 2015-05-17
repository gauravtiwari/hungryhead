class User < ActiveRecord::Base

  include IdentityCache

  #External modules
  include ActiveModel::Validations
  include Rails.application.routes.url_helpers
  #redis objects
  include Redis::Objects
  #order objects in same order as given
  extend OrderAsSpecified

  extend FriendlyId
  friendly_id :slug_candidates

  #Scopes for searching
  scope :entrepreneurs, -> { where(role: 1) }
  scope :users, -> { where(role: 0) }

  has_merit

  #Concerns for User class
  include Followable
  include Follower
  include Mentionable
  include Suggestions
  include Scorable
  include Feedbacker
  include Investor
  include Commenter
  include Voter

  attr_accessor :login

  #Model Relationships
  belongs_to :school

  has_many :authentications, :dependent => :destroy
  has_many :activities, :dependent => :destroy
  has_many :notifications, :dependent => :destroy
  has_many :posts, dependent: :destroy
  has_many :slugs, as: :sluggable, dependent: :destroy

  cache_index :slug
  cache_index :sash_id
  cache_index :level
  cache_index :school_id

  cache_has_many :notifications, :embed => true
  cache_has_many :activities, :embed => true
  cache_has_many :posts, :embed => true
  cache_has_many :slugs, :inverse_name => :sluggable, :embed => true
  cache_has_many :followers, :inverse_name => :followable, :embed => true
  cache_has_many :feedbacks, :embed => true
  cache_has_many :investments, :embed => true
  cache_has_many :followings, :inverse_name => :follower, :embed => true

  #Callbacks
  before_save :add_fullname, if: :name_not_present?
  before_save :add_username, if: :username_absent?
  before_destroy :remove_from_soulmate, :decrement_counters, :delete_activity, unless: :is_admin
  before_save :seed_fund, :seed_settings, unless: :is_admin
  after_create :increment_counters
  after_save :load_into_soulmate, :create_slug, unless: :is_admin

  #Tagging System
  acts_as_taggable_on :hobbies, :locations, :subjects, :markets
  acts_as_tagger

  #Sorted set to store followers, followings ids and latest activities
  set :followers_ids
  set :followings_ids
  set :idea_followings_ids
  set :school_followings_ids

  #Latest ideas
  list :latest_ideas, maxlength: 5, marshal: true
  #List to store latest users
  list :latest, maxlength: 20, marshal: true, global: true

  #Store latest user notifications
  sorted_set :ticker, marshal: true
  sorted_set :friends_notifications, marshal: true

  #List to store last 10 activities
  list :latest_activities, maxlength: 5, marshal: true

  #Sorted set to store trending ideas
  sorted_set :leaderboard, global: true
  sorted_set :trending, global: true

  #Redis counters to cache total followers, followings,
  #feedbacks, investments and ideas
  counter :followers_counter
  counter :followings_counter

  counter :feedbacks_counter
  counter :investments_counter

  counter :comments_counter
  counter :votes_counter
  counter :ideas_counter
  counter :posts_counter
  counter :views_counter
  counter :shares_counter

  #Enumerators to handle states
  enum state: { inactive: 0, published: 1}
  enum role: { user: 0, student: 1, entrepreneur: 2, mentor: 3, teacher: 4 }

  #Accessor methods for JSONB datatypes
  store_accessor :profile, :facebook_url, :twitter_url, :linkedin_url, :website_url
  store_accessor :media, :avatar_position, :cover_position, :cover_left,
  :cover_processing, :avatar_processing
  store_accessor :settings, :theme, :idea_notifications, :post_notifications, :feedback_notifications,
  :investment_notifications, :follow_notifications, :weekly_mail
  store_accessor :fund, :balance, :invested_amount, :earned_amount

  #Devise for authentication
  devise :invitable, :async, :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :confirmable,
    :registerable, :authentication_keys => [:login]


  #Media Uploaders - carrierwave
  mount_uploader :avatar, LogoUploader
  mount_uploader :cover, CoverUploader

  #Model Validations
  validates :email, :presence => true, :uniqueness => {:case_sensitive => false}
  validates :name, :presence => true
  validates :username, :presence => true, :uniqueness => true, format: { with: /\A[a-zA-Z0-9]+\Z/, message: "should not contain empty spaces or symbols" }
  validates :password, :confirmation => true, :presence => true, :length => {:within => 6..40}, :on => :create

  #Get username suggestions
  suggestions_for :username, :num_suggestions => 5,
      :first_name_attribute => :firstname, :last_name_attribute => :lastname

  #Messaging system
  acts_as_messageable

  #Public methods
  public

  def can_score?
    true
  end

  def joined_within_a_year?
    (DateTime.now.to_date - self.created_at.to_date).to_i <= 365
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

  def rebuild_notifications
    if rebuild_cache? && has_notifications?
      unless admin?
        #rebuild user feed every time name and avatar update.
        RebuildNotificationsCacheJob.set(wait: 5.seconds).perform_later(id)
      end
    end
  end

  private

  def create_slug
    return if slug == slugs.last.try(:slug)
    previous = slugs.where('lower(slug) = ?', slug.downcase)
    previous.delete_all
    slugs.create!(slug: slug)
  end

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end

  #returns if a user is admin
  def is_admin
    admin?
  end

  def name_not_present?
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
        email_username = "#{name.parameterize}#{num}"
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
      post_notifications: true,
      weekly_mail: true
    }
  end

  #Slug attributes for friendly id
  def slug_candidates
    [:username]
  end

  def rebuild_cache?
    #check if basic info changed and user is not new
    name_changed? || avatar_changed? || username_changed? && !id_changed?
  end

  def has_notifications?
    #check if user has notifications
    ticker.members.length > 0
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
    school.latest_students << id if school_id.present? && self.type == "Student"
    school.latest_faculties << id if school_id.present? && self.type == "Teacher"
    #Cache sorted set for global leaderboard
    User.latest << id unless type == "User"

    #Add leaderboard score
    User.leaderboard.add(id, points)
    User.trending.add(id, 1)
  end

  def decrement_counters
    #Decrement counters
    school.students_counter.decrement if school_id.present? && school.students_counter.value > 0 && self.type == "Student"
    #delete cached lists for school
    school.latest_students.delete(id) if school_id.present? && self.type == "Student"
    school.latest_faculties.delete(id) if school_id.present? && self.type == "Teacher"
    #delete cached sorted set for global leaderboard
    User.latest.delete(id) unless type == "User"

    #delete leaderboard for this user
    User.leaderboard.delete(id)
    User.trending.delete(id)
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
