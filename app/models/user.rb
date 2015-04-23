class User < ActiveRecord::Base

  include ActiveModel::Validations
  include Redis::Objects
  include PublicActivity::Model
  activist
  extend FriendlyId

  friendly_id :slug_candidates

  def slug_candidates
    [:username]
  end

  acts_as_taggable_on :skills, :locations, :subjects, :markets,
  :services, :technologies
  acts_as_tagger
  acts_as_punchable

  #Sorted set to store followers, followings ids and latest activities
  sorted_set :followers_ids
  sorted_set :followings_ids
  sorted_set :idea_followings_ids
  sorted_set :latest_activities, maxlength: 100, marshal: true

  #Redis counters to cache total followers, followings,
  #feedbacks, investments and ideas
  counter :followers_counter
  counter :followings_counter
  counter :feedbacks_counter
  counter :investments_counter
  counter :ideas_counter

  #Enumerators to handle states
  enum state: { inactive: 0, published: 1}
  enum role: { user: 0, entrepreneur: 1, mentor: 2 }

  #Accessor methods for JSONB datatypes
  store_accessor :profile, :facebook_url, :twitter_url, :linkedin_url, :website_url

  store_accessor :media, :avatar_position, :cover_position, :cover_left,
  :cover_processing, :avatar_processing

  store_accessor :settings, :theme, :idea_notification_email, :feedback_notification_email,
  :investment_notification_email, :follow_notification_email

  store_accessor :fund, :balance, :invested_amount, :earned_amount

  serialize [:fund, :education, :interests, :profile, :settings], HashSerializer

  attr_accessor :avatar_crop_x, :avatar_crop_y, :avatar_crop_w, :avatar_crop_h

  #Merit GEM for badges and points
  has_merit

  #Devise for authentication
  devise :invitable, :async, :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :confirmable,
    :registerable, :authentication_keys => [:login]

  attr_accessor :login

  #Model Relationships
  belongs_to :school, counter_cache: true
  has_many :authentications, :dependent => :destroy, autosave: true
  has_many :shares, dependent: :destroy, autosave: true
  has_many :feedbacks, dependent: :destroy, autosave: true
  has_many :investments, dependent: :destroy, autosave: true
  has_many :comments, dependent: :destroy, autosave: true
  has_many :notifications, :foreign_key => :reciever_id, dependent: :destroy, autosave: true
  has_many :slugs, as: :sluggable, dependent: :destroy

  #Media Uploaders - carrierwave
  mount_uploader :avatar, LogoUploader
  mount_uploader :cover, CoverUploader

  #Scopes for searching
  scope :entrepreneurs, -> { where(role: 1) }
  scope :users, -> { where(role: 0) }

  #Callbacks
  before_save :add_fullname
  before_save :seed_fund
  after_save :create_slug
  after_save :load_into_soulmate
  before_destroy :remove_from_soulmate
  after_create :increment_counters
  before_destroy :decrement_counters

  #Follower/Follow System
  acts_as_follower
  acts_as_followable
  acts_as_voter

  #Model Validations
  validates :email, :presence => true, :uniqueness => {:case_sensitive => false}
  validates :name, :presence => true
  validates :username, :presence => true, :uniqueness => true, format: { with: /\A[a-zA-Z0-9]+\Z/, message: "should not contain empty spaces or symbols" }

  validates :password, :confirmation => true, :presence => true, :length => {:within => 6..40}, :on => :create

  #Messaging system
  acts_as_messageable


  def mailboxer_email(object)
    email
  end

  def balance_available?(amount)
    balance > amount.to_i
  end

  #Override Devise's update with password to allow registration edits without password entry
  def update_with_password(params={})
    params.delete(:current_password)
    self.update_without_password(params)
  end

  #Methods to check if action is performed  - follow/share/vote
  def follower?(user)
    followers_ids.members.include?(user.id.to_s)
  end

  def shared?(shareable)
    shareable.sharers_ids.members.include?(id.to_s)
  end

  def voted?(votable)
    votable.voters_ids.members.include?(id.to_s)
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

  private

  def add_fullname
    words = self.name.split(" ")
    self.first_name = words.first
    self.last_name =  words.last
  end

  def seed_fund
    self.fund = {balance: 1000}
  end

  def should_generate_new_friendly_id?
    slug.blank? || username_changed?
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def create_slug
  	return if !slug_changed? || slug == slugs.last.try(:slug)
  	previous = slugs.where('lower(slug) = ?', slug.downcase)
  	previous.delete_all
  	slugs.create!(slug: slug)
  end

  def load_into_soulmate
    if type == "Student"
      soulmate_loader("students")
    elsif type == "Mentor"
      soulmate_loader("mentors")
    elsif type == "Teacher"
      soulmate_loader("teachers")
    end
  end

  def soulmate_loader(type)
    loader = Soulmate::Loader.new(type)
    if avatar
      image =  avatar.url(:avatar)
      resume = school.name
    else
      image= "http://placehold.it/30"
    end
    loader.add("term" => name, "image" => image, "description" => resume, "id" => id, "data" => {
      "link" => Rails.application.routes.url_helpers.profile_path(self)
      })
  end

  def remove_from_soulmate
    loader = Soulmate::Loader.new("students")
      loader.remove("id" => id)
  end

  def increment_counters
    school.students_counter.increment
  end

  def decrement_counters
    school.students_counter.decrement
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
