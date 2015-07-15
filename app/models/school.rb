class School < ActiveRecord::Base

	#Model caching
	include IdentityCache
	#redis objects
	include Redis::Objects

	#Included concerns
	include Followable
	include Sharings
	include Feeder
	include Sluggable
	include Eventable

	#Model Validations
	validates :email, :presence => true, :uniqueness => {:case_sensitive => false}
	validates :name, :presence => true
	validates :username, :presence => true, :length => {:within => 3..40}, :uniqueness => true, format: { with: /\A[a-zA-Z0-9-_]+\Z/, message: "should not contain empty spaces or symbols" }
	validates :password, :confirmation => true, :presence => true, :length => {:within => 6..40}, :on => :create

	#Devise for authentication
	devise :invitable, :uid, :database_authenticatable,
	  :recoverable, :rememberable, :lockable, :trackable, :validatable,
	  :authentication_keys => [:login]

	#Relationship
	has_many :students, -> { where(state: 1, role: 1)}, class_name: 'User'
	has_many :ideas, -> { where(status: 1, privacy: 1) }, class_name: 'Idea'
	has_many :faculties, -> { where(state: 1, role: 4) }, class_name: 'User'

	has_many :school_admins

	cache_has_many :students, embed: true
	cache_has_many :faculties, embed: true
	#cache_has_many :events, :inverse_name => :eventable, embed: true
	cache_has_many :ideas, embed: true
	cache_has_many :school_admins

	cache_index :slug, :unique => true

	acts_as_taggable_on :locations

	store_accessor :media, :logo_position, :logo_tmp, :cover_tmp,
	:cover_position, :cover_left, :cover_prcessing, :logo_processing

	#Redis Cache counters and ids
	set :followers_ids

	#List to store last 5 activities
	sorted_set :latest_activities, marshal: true

	#Store latest school notifications
	sorted_set :ticker, marshal: true
	sorted_set :friends_notifications, marshal: true

	#Counters
	counter :followers_counter
	counter :people_counter
	counter :ideas_counter

	#Mount carrierwave
	mount_uploader :logo, LogoUploader
	mount_uploader :cover, CoverUploader

	validates :name, :presence => true,
	:on => :create

	public

	#Slug candidates for school
	def slug_candidates
	 [:name]
	end

	#Login using both email and username
	def login=(login)
	  @login = login
	end

	def login
	  @login || self.username || self.email
	end

	def get_published_faculties
		fetch_faculties.sort { |x,y| y.created_at <=> x.created_at }
	end

	def get_published_ideas
		fetch_ideas.sort { |x,y| y.created_at <=> x.created_at }
	end

	def get_published_students
		fetch_students.sort { |x,y| y.created_at <=> x.created_at }
	end

	#Callbacks hooks
	after_save :load_into_soulmate
  before_destroy :remove_from_soulmate

  def can_score?
  	true
  end

  def name_badge
  	words = name.split(' ')
  	words.first(3).map{|w| w.first }.join.upcase
  end

	private

	def should_generate_new_friendly_id?
	  slug.blank? || name_changed?
	end

	def load_into_soulmate
		loader = Soulmate::Loader.new("schools")
		loader.add(
			"term" => name,
			"image" => logo.url(:avatar),
			"description" => location_list,
			"id" => id,
			"data" => {
		  	"link" => Rails.application.routes.url_helpers.profile_path(self)
		  })
	end

	def remove_from_soulmate
		loader = Soulmate::Loader.new("universities")
	  loader.remove("id" => id)
	end

end
