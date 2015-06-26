class User < ActiveRecord::Base

  include IdentityCache
  acts_as_copy_target

  #External modules
  include ActiveModel::Validations
  include Rails.application.routes.url_helpers

  #redis objects
  include Redis::Objects
  #order objects in same order as given
  extend OrderAsSpecified

  #Scopes for searching
  scope :students, -> { where(role: 1) }
  scope :entrepreneurs, -> { where(role: 2) }
  scope :mentors, -> { where(role: 3) }
  scope :faculties, -> { where(role: 4) }
  scope :users, -> { where(role: 0) }
  scope :published, -> { where(state: 1) }

  #Gamification
  has_merit

  #Concerns for User class
  include Sluggable
  include Followable
  include Follower
  include Mentionable
  include Suggestions
  include Scorable
  include Feedbacker
  include Investor
  include Commenter
  include Voter
  include Activist
  include Impressionable
  include Impressioner
  include Eventable

  attr_accessor :login
  attr_reader :raw_invitation_token

  #Model Relationships
  belongs_to :school

  #has_many relationships
  has_many :authentications, :dependent => :destroy
  has_many :activities, :dependent => :destroy
  has_many :notifications, :dependent => :destroy
  has_many :ideas, dependent: :destroy, autosave: true
  has_many :idea_messages, dependent: :destroy, autosave: true

  cache_has_many :ideas, embed: true
  cache_belongs_to :school

  cache_index :slug, :unique => true
  cache_index :state, :school_id
  cache_index :role, :school_id
  cache_index :email, :school_id
  cache_index :state
  cache_index :role
  cache_index :email
  cache_index :uid
  cache_index :school_id

  #Callbacks
  before_create :add_fullname, if: :name_not_present?
  before_create :add_username, if: :username_absent?
  before_destroy :remove_from_soulmate, :decrement_counters, :delete_activity, unless: :is_admin
  before_create :seed_fund, :seed_settings, unless: :is_admin

  #Call Service to update cache
  after_save do |user|
    RecordSavedJob.set(wait: 1.minute).perform_later(user.id, "User") if rebuild_search?
    RebuildNotificationsCacheJob.set(wait: 1.minute).perform_later(id) if rebuild_cache? && published?
  end

  #Tagging System
  acts_as_taggable_on :hobbies, :locations, :markets, :skills, :subjects
  acts_as_tagger

  #Sorted set to store followers, followings ids and latest activities
  set :followers_ids
  set :followings_ids
  set :idea_followings_ids
  set :school_followings_ids
  set :impressioners_ids

  #Latest ideas
  list :latest_ideas, maxlength: 5, marshal: true
  #List to store latest users
  list :latest, maxlength: 20, marshal: true, global: true

  #List to store last 5 activities
  sorted_set :latest_activities, marshal: true

  #Store latest user notifications
  sorted_set :ticker, marshal: true
  sorted_set :friends_notifications, marshal: true

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
  counter :views_counter
  counter :activities_counter

  #Enumerators to handle states
  enum state: { inactive: 0, published: 1}
  enum role: { user: 0, student: 1, entrepreneur: 2, mentor: 3, faculty: 4 }

  #Accessor methods for JSONB datatypes
  store_accessor :profile, :facebook_url, :twitter_url, :linkedin_url, :website_url
  store_accessor :media, :avatar_position, :cover_position, :cover_left,
  :cover_processing, :avatar_processing, :avatar_tmp, :cover_tmp
  store_accessor :settings, :theme, :idea_notifications, :feedback_notifications,
  :investment_notifications, :follow_notifications, :weekly_mail
  store_accessor :fund, :balance, :invested_amount, :earned_amount
  #JSONB postgres store  accessors
  store_accessor :interests, :locations, :hobbies, :markets

  #Devise for authentication
  devise :invitable, :uid, :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :confirmable,
    :registerable, :authentication_keys => [:login]


  #Media Uploaders - carrierwave
  mount_uploader :avatar, LogoUploader
  mount_uploader :cover, CoverUploader

  #Model Validations
  validates :email, :presence => true, :uniqueness => {:case_sensitive => false}
  validates :name, :presence => true
  validates :username, :presence => true, :length => {:within => 3..40}, :uniqueness => true, format: { with: /\A[a-zA-Z0-9-]+\Z/, message: "should not contain empty spaces or symbols" }
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

  def school_owner?
    school_admin?
  end

  def after_password_reset; end

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

  def unread_notifications
    friends_notifications.members.select{|m| m[:unread] == true}.count
  end

  def firstname
    self.name.split(' ').first
  end

  def lastname
    self.name.split(' ').second
  end

  def rebuild_search?
    published?
  end

  def rebuild_cache?
    #check if basic info changed and user is not new
    name_changed? || avatar_changed? || username_changed? && !id_changed?
  end

  def has_notifications?
    #check if user has notifications
    ticker.members.length > 0
  end

  def email_required?
    super && authentications.blank?
  end
  def password_required?
    super && authentications.blank?
  end

  #Override Devise's update with password to allow registration edits without password entry
  def update_with_password(params={})
    params.delete(:current_password)
    self.update_without_password(params)
  end

  private

  #returns if a user is admin
  def is_admin
    admin?
  end

  def should_generate_new_friendly_id?
    slug.blank? || username_changed?
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
      while(User.find_by_username(email_username).blank?)
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
      theme: "#{role.downcase}",
      idea_notifications: true,
      feedback_notifications: true,
      investment_notifications: true,
      follow_notifications: true,
      weekly_mail: true
    }
  end

  #Slug attributes for friendly id
  def slug_candidates
    [:username]
  end

  def remove_from_soulmate
    #Remove search index if :record destroyed
    loader = Soulmate::Loader.new("people")
    loader.remove("id" => id)
  end

  def decrement_counters
    #Decrement counters
    school.people_counter.decrement if school_id.present? && school.people_counter.value > 0
    #delete cached lists for school
    school.latest_people.delete(id) if school_id.present?
    #delete cached sorted set for global leaderboard
    User.latest.delete(id)

    #delete leaderboard for this user
    User.leaderboard.delete(id)
    User.trending.delete(id)
  end

  #Deletes all dependent activities for this user
  def delete_activity
    DeleteUserFeedJob.perform_later(self.id, self.class.to_s)
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
