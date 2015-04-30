class User < ActiveRecord::Base

  include ActiveModel::Validations
  include IdentityCache
  include Redis::Objects
  include Wisper.model

  #Concerns for User class
  include Followable
  include Follower
  include Mentionable
  include Sluggable

  acts_as_taggable_on :hobbies, :locations, :subjects, :markets
  acts_as_tagger
  acts_as_punchable

  #Sorted set to store followers, followings ids and latest activities
  set :followers_ids
  set :followings_ids
  set :idea_followings_ids
  set :ideas_ids

  #Store latest user notifications
  set :latest_notifications, maxlength: 100, marshal: true
  sorted_set :notification_feed

  #Redis counters to cache total followers, followings,
  #feedbacks, investments and ideas
  counter :followers_counter
  counter :followings_counter
  counter :feedbacks_counter
  counter :investments_counter
  counter :ideas_counter
  counter :views_counter

  #Enumerators to handle states
  enum state: { inactive: 0, published: 1}
  enum role: { user: 0, entrepreneur: 1, mentor: 2 }

  #Accessor methods for JSONB datatypes
  store_accessor :profile, :facebook_url, :twitter_url, :linkedin_url, :website_url
  store_accessor :media, :avatar_position, :cover_position, :cover_left,
  :cover_processing, :avatar_processing
  store_accessor :settings, :theme, :idea_notifications, :note_notifications, :feedback_notifications,
  :investment_notifications, :follow_notifications, :weekly_mail
  store_accessor :fund, :balance, :invested_amount, :earned_amount
  serialize [:fund, :education, :interests, :profile, :settings], HashSerializer

  #Merit GEM for badges and points
  has_merit

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
  has_many :feedbacks, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :investments, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :slugs, as: :sluggable, dependent: :destroy

  #Caching Model
  cache_has_many :activities, :embed => true
  cache_has_many :followings, :inverse_name => :follower, :embed => true
  cache_has_many :followers, :inverse_name => :followable, :embed => true
  cache_has_many :investments, :embed => true
  cache_has_many :feedbacks, :embed => true
  cache_has_many :activities, :embed => true
  cache_has_many :notifications, :embed => true

  cache_index :school_id
  cache_index :type
  cache_index :slug

  #Media Uploaders - carrierwave
  mount_uploader :avatar, LogoUploader
  mount_uploader :cover, CoverUploader

  #Scopes for searching
  scope :entrepreneurs, -> { where(role: 1) }
  scope :users, -> { where(role: 0) }

  #Model Validations
  validates :email, :presence => true, :uniqueness => {:case_sensitive => false}
  validates :name, :presence => true
  validates :username, :presence => true, :uniqueness => true, format: { with: /\A[a-zA-Z0-9]+\Z/, message: "should not contain empty spaces or symbols" }
  validates :password, :confirmation => true, :presence => true, :length => {:within => 6..40}, :on => :create

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

  def email_required?
    super && authentications.blank?
  end

  def password_required?
    super && authentications.blank?
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later!(wait: 5.seconds)
  end

  #returns if a user is admin
  def is_admin
    admin?
  end

  #return user school name
  def school_name
    school_id.present? ? school.name : ""
  end

  #returns user short name badghe
  def user_name_badge
    first_name.present? ? first_name.first + last_name.first : name
  end

  private

  #Slug attributes for friendly id
  def slug_candidates
    [:username]
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
