class School < ActiveRecord::Base

	include IdentityCache
	include Redis::Objects
	include Followable
	include Sluggable

	has_many :users
	has_many :ideas

	acts_as_taggable_on :locations

	store_accessor :data, :established, :locations, :website
	store_accessor :media, :logo_position,
	:cover_position, :cover_prcessing, :logo_processing

	#Redis Cache counters and ids
	sorted_set :followers_ids
	sorted_set :students_ids
	sorted_set :ideas_ids

	#Counters
	counter :followers_counter
	counter :students_counter
	counter :ideas_counter

	#Caching Model
	cache_has_many :followers, :inverse_name => :followable, :embed => true
	cache_index :slug
	cache_index :name

	#Mount carrierwave
	mount_uploader :logo, LogoUploader
	mount_uploader :cover, CoverUploader

	validates :name, :presence => true,
	:on => :create

	#Slug candidates for school
	def slug_candidates
	 [:name]
	end

	#Callbacks hooks
	after_save :load_into_soulmate
  before_destroy :remove_from_soulmate

  def can_score?
  	true
  end

  def update_counters
  	students_counter.reset
  	ideas_counter.reset
  	followers_counter.reset
  	students_counter.incr(users.size)
  	ideas_counter.incr(ideas.size)
  	followers_counter.incr(followers.size)
  end

	private

	def load_into_soulmate
		loader = Soulmate::Loader.new("schools")
		if logo
		  image =  logo.url(:avatar)
		  resume = location_list.first
		else
		  image= "http://placehold.it/30"
		end
		loader.add("term" => name, "image" => image, "description" => resume, "id" => id, "data" => {
		  "link" => Rails.application.routes.url_helpers.profile_path(self)
		  })
	end

	def remove_from_soulmate
		loader = Soulmate::Loader.new("universities")
	  	loader.remove("id" => id)
	end

end
