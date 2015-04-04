class User < ActiveRecord::Base

  include ActiveModel::Validations
  extend FriendlyId
  friendly_id :slug_candidates
  def slug_candidates
    [:username]
  end

  include PublicActivity::Model

  enum state: { inactive: 0, published: 1}
  enum role: { user: 0, entrepreneur: 1, mentor: 2 }

  acts_as_taggable_on :skills, :locations, :subjects, :markets,
  :services, :technologies

  acts_as_tagger

  store_accessor :profile, :facebook_url, :twitter_url, :linkedin_url, :website_url
  store_accessor :education, :subjects
  store_accessor :interests, :locations, :technologies, :skills, :markets, :services
  store_accessor :media, :avatar_position, :cover_position,
  :cover_processing, :avatar_processing
  store_accessor :settings, :weekly_email
  store_accessor :fund, :balance, :invested_amount, :earned_amount

  serialize [:fund, :education, :interests, :profile, :settings], HashSerializer

  attr_accessor :avatar_crop_x, :avatar_crop_y, :avatar_crop_w, :avatar_crop_h

  has_merit

  devise :invitable, :omniauthable, :async, :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :confirmable,
    :registerable, :authentication_keys => [:login]

  attr_accessor :login

  #Model Relationships
  belongs_to :school, counter_cache: true
  has_one :school, -> { where teacher: true } 
  has_many :authentications, :dependent => :destroy, autosave: true
  has_many :ideas, dependent: :destroy, autosave: true
  has_many :shares, dependent: :destroy, autosave: true
  has_many :feedbacks, dependent: :destroy, autosave: true
  has_many :idea_messages, dependent: :destroy, autosave: true
  has_many :investments, dependent: :destroy, autosave: true
  has_many :comments, dependent: :destroy, autosave: true
  has_many :notifications, :foreign_key => :reciever_id, dependent: :destroy, autosave: true

  has_many :slugs, as: :sluggable, dependent: :destroy

  mount_uploader :avatar, LogoUploader
  mount_uploader :cover, CoverUploader

  scope :entrepreneurs, -> { where(role: 1) }
  scope :users, -> { where(role: 0) }
 
  before_create :seed_fund
  after_save :create_slug

  acts_as_follower
  acts_as_followable
  acts_as_voter

  validates :email, :presence => true, :uniqueness => {:case_sensitive => false}
  validates :name, :presence => true
  validates :username, :presence => true, :uniqueness => true
  validates :password, :confirmation => true, :presence => true, :length => {:within => 6..40}, :on => :create

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

  def shared? shareable, args={}
    shares = find_shares(:shareable_id => shareable.id, :shareable_type => shareable.class.name)
    shares.size > 0
  end

  private

  def find_shares extra_conditions = {}
    shares.where(extra_conditions)
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
  	#re-use old slugs
  	previous = slugs.where('lower(slug) = ?', slug.downcase)
  	previous.delete_all
  	slugs.create!(slug: slug)
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
