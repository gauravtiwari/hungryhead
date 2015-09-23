class User < ActiveRecord::Base

  #Order objects as specified in array
  extend OrderAsSpecified

  #Don't delete straightaway
  acts_as_paranoid

  #External modules
  include ActiveModel::Validations
  include Rails.application.routes.url_helpers
  #redis objects
  include Redis::Objects

  #Callbacks
  before_create :seed_fund, :seed_settings, unless: :admin?
  before_create :add_fullname, unless: :name_present?
  before_create :add_username, unless: :username_present?
  before_destroy :remove_from_soulmate, :decrement_counters, unless: :admin?

  #Call Service to update cache
  after_save :soulmate_loader, if: :rebuild_cache?
  after_update :rebuild_notifications, if: :cacheable_changed?

  #copy records
  acts_as_copy_target

  #Scopes for searching
  scope :students, -> { where(state: 1, role: 1) }
  scope :from_school, ->(school_id) { where(state: 1, :school_id => school_id)}
  scope :entrepreneurs, -> { where(state: 1, role: 2) }
  scope :faculties, -> { where(state: 1, role: 4) }
  scope :users, -> { where(state: 1, role: 0) }
  scope :published, -> { where(state: 1) }

  #Gamification
  has_merit

  #Concerns for User class
  include Sluggable
  include Followable
  include Follower
  include Feeder
  include Mentionable
  include Suggestions
  include Scorable
  include Feedbacker
  include Investor
  include Commenter
  include Voter
  include Sharings
  include Activist
  include Impressionable
  include Impressioner
  include Eventable

  attr_accessor :login
  attr_reader :raw_invitation_token

  #Model Relationships
  belongs_to :school, touch: true

  #has_many relationships
  has_many :attendences, class_name: 'EventAttendee', foreign_key: 'attendee_id', :dependent => :destroy
  has_many :team_invites, class_name: 'TeamInvite', foreign_key: 'invited_id', :dependent => :destroy

  has_many :ideas, dependent: :destroy, autosave: true
  has_many :idea_messages, dependent: :destroy, autosave: true

  #Tagging System
  acts_as_taggable_on :hobbies, :locations, :markets, :skills, :subjects
  acts_as_tagger

  #Sorted set to store followers, followings ids and latest activities
  set :followers_ids
  set :followings_ids
  set :school_followings_ids
  set :impressioners_ids

  #List to store latest users
  list :latest, maxlength: 20, marshal: true, global: true

  #Store latest user notifications
  sorted_set :ticker, marshal: true
  sorted_set :friends_notifications, marshal: true

  #Sorted set to store trending ideas
  sorted_set :latest, global: true
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

  #Count user notifications
  counter :notifications_counter

  #Enumerators to handle states
  enum state: { inactive: 0, published: 1}
  enum feed_preferences: { latest_stories: 0, popular_stories: 1 }
  enum role: { user: 0, student: 1, entrepreneur: 2, alumni: 3, faculty: 4 }

  #Accessor methods for JSONB datatypes
  store_accessor :profile, :facebook_url,
  :twitter_url, :linkedin_url, :website_url
  store_accessor :media, :avatar_position, :cover_position, :cover_left,
  :cover_processing, :avatar_processing, :avatar_tmp, :cover_tmp
  store_accessor :settings, :theme, :idea_notifications, :feedback_notifications,
  :investment_notifications, :follow_notifications, :weekly_mail
  store_accessor :fund, :balance, :invested_amount, :earned_amount

  #Devise for authentication
  devise :invitable, :uid, :database_authenticatable, :registerable,
    :recoverable, :rememberable, :lockable, :trackable, :validatable, :confirmable,
    :authentication_keys => [:login]


  #Media Uploaders - carrierwave
  mount_uploader :avatar, LogoUploader
  mount_uploader :cover, CoverUploader

  #Model Validations
  validates :email, :presence => true, :uniqueness => {:case_sensitive => false}
  validates :name, :presence => true
  validates :username, :presence => true, :length => {:within => 3..40}, :uniqueness => true, format: { with: /\A[a-zA-Z0-9](\w|\.)*[a-zA-Z0-9]$\Z/, message: "should not contain empty spaces or symbols" }
  validates :password, :confirmation => true, :presence => true, :length => {:within => 6..40}, :on => :create
  #Get username suggestions
  suggestions_for :username, :num_suggestions => 5,
      :first_name_attribute => :firstname, :last_name_attribute => :lastname

  #Public methods
  public

  def self.current
    Thread.current[:user]
  end

  def self.current=(user)
    Thread.current[:user] = user
  end

  def name_present?
    name.present?
  end

  def username_present?
    username.present?
  end

  def get_contributions
    Idea.includes(:user).find_each.select{|idea| idea.contributers.include?(id.to_s) && !idea.team_ids.include?(id.to_s) && idea.user_id != id  }
  end

  def send_welcome_email!
    RegistrationMailer.welcome_email(self.id).deliver_later(wait: 5.seconds)
  end

  def after_password_reset; end

  def joined_within_a_year?
    (DateTime.now.to_date - self.created_at.to_date).to_i <= 365
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

  #Save user without confirmation
  def save_without_confirmation
    self.skip_confirmation_notification!
    self.save!
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later!(wait: 5.seconds)
  end

  def get_avatar
    avatar.url(:avatar)
  end

  def avatar_present?
    avatar.url(:avatar).present?
  end

  def school_name
    school_id.present? ? school.name : ""
  end

  def name_badge
    first_name.present? ? first_name.first + last_name.first : add_fullname
  end

  def firstname
    self.name.split(' ').first
  end

  def lastname
    self.name.split(' ').second
  end

  def cacheable_changed?
    name_changed? || avatar_changed? || username_changed? || mini_bio_changed? && has_notifications?
  end

  def rebuild_cache?
     published? || id_changed? || name_changed? || avatar_changed? || mini_bio_changed?
  end

  def rebuild_notifications
    UpdateActivityJob.set(wait: 1.minute).perform_later(self.id)
  end

  def has_notifications?
    #check if user has notifications
    ticker.members.length > 0
  end

  def card_json
    {
      id: uid,
      name: name,
      name_badge: name_badge,
      avatar: get_avatar,
      updated_at: updated_at,
      url: profile_path(self),
      description: mini_bio
    }
  end


  private

  #returns if a user is admin
  def is_admin
    admin?
  end

  def should_generate_new_friendly_id?
    slug.blank? || username_changed?
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

  def soulmate_loader
    RecordSavedJob.set(wait: 1.minute).perform_later(id, self.class.to_s)
  end

  def remove_from_soulmate
    #Remove search index if :record destroyed
    loader = Soulmate::Loader.new("people")
    loader.remove("id" => id)
    true
  end

  def decrement_counters
    #delete cached sorted set for global leaderboard
    User.latest.delete(id)
    #delete leaderboard for this user
    User.leaderboard.delete(id)
    User.trending.delete(id)
    #Decrement counters
    school.people_counter.reset
    school.people_counter.incr(User.from_school(school_id).size) if school_id.present?
    true
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
