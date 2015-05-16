class User < ActiveRecord::Base

  include Wisper::Publisher

  #External modules
  include ActiveModel::Validations

  #order objects in same order as given
  extend OrderAsSpecified

  #Scopes for searching
  scope :entrepreneurs, -> { where(role: 1) }
  scope :users, -> { where(role: 0) }

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

  #user related concerns - redis and after_destroy methods
  include UserConcerns

  attr_accessor :login

  #Model Relationships
  belongs_to :school

  has_many :authentications, :dependent => :destroy
  has_many :activities, :dependent => :destroy
  has_many :notifications, :dependent => :destroy
  has_many :posts, dependent: :destroy

  after_create do |user|
    #increment counters
    broadcast(:record_created, user)
  end

  after_save do |user|
    #rebuild cache
    broadcast(:sluggable_saved, user)
    broadcast(:record_saved, user)
  end

  #Callbacks
  before_save :add_fullname
  before_save :add_username, if: :username_absent?
  before_save :seed_data, unless: :is_admin
  before_destroy :remove_from_soulmate, :decrement_counters, :delete_activity, unless: :is_admin

  #Accessor methods for JSONB datatypes
  store_accessor :profile, :facebook_url, :twitter_url, :linkedin_url, :website_url
  store_accessor :media, :avatar_position, :cover_position, :cover_left,
  :cover_processing, :avatar_processing
  store_accessor :settings, :theme, :idea_notifications, :post_notifications, :feedback_notifications,
  :investment_notifications, :follow_notifications, :weekly_mail
  store_accessor :fund, :balance, :invested_amount, :earned_amount
  serialize [:fund, :education, :interests, :profile, :settings], HashSerializer

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

  #returns if a user is admin
  def is_admin
    admin?
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

  #Seeds settings into database on: :create
  def seed_data
    self.settings = {
      theme: 'solid',
      idea_notifications: true,
      feedback_notifications: true,
      investment_notifications: true,
      follow_notifications: true,
      post_notifications: true,
      weekly_mail: true
    }
    self.fund = {balance: 1000}
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

end
