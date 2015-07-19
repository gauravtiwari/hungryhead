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

	#Relationship
	has_many :students, -> { where(state: 1, role: 1)}, class_name: 'User'
	has_many :ideas, -> { where(status: 1, privacy: 1) }, class_name: 'Idea'
	has_many :faculties, -> { where(state: 1, role: 4) }, class_name: 'User'
	has_many :users, -> { where(state: 1) }, class_name: 'User'
	has_many :school_admins
	belongs_to :user, class_name: 'User'

	#Cache into memcache
	cache_has_many :students, embed: true
	cache_has_many :users, embed: true
	cache_has_many :faculties, embed: true
	cache_has_many :ideas, embed: true
	cache_has_many :school_admins
	cache_belongs_to :user

	#Cache index for fetching school
	cache_index :slug, :unique => true
	cache_index :uuid, :unique => true

	#Tagging for locations
	acts_as_taggable_on :locations

	store_accessor :media, :logo_position, :logo_tmp, :cover_tmp,
	:cover_position, :cover_left, :cover_prcessing, :logo_processing

	#Redis Cache counters and ids
	set :followers_ids

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

	def get_published_faculties
		fetch_faculties.sort { |x,y| y.created_at <=> x.created_at }
	end

	def get_published_users
		fetch_users.sort { |x,y| y.created_at <=> x.created_at }
	end

	def get_avatar
	  logo.url
	end

	def avatar_present?
	  logo.url(:avatar).present?
	end

	def get_published_ideas
		fetch_ideas.sort { |x,y| y.created_at <=> x.created_at }
	end

	def get_published_events
		fetch_events.sort { |x,y| y.created_at <=> x.created_at }
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
