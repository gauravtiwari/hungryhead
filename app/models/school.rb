class School < ActiveRecord::Base

	#redis objects
	include Redis::Objects

	#Included concerns
	include Followable
	include Sluggable

	#Relationship
	has_many :users
	has_many :ideas

	acts_as_taggable_on :locations

	store_accessor :data, :established, :locations, :website
	store_accessor :media, :logo_position,
	:cover_position, :cover_left, :cover_prcessing, :logo_processing

	#Redis Cache counters and ids
	set :followers_ids

	#Latest caches
	list :latest_students, maxlength: 20, marshal: true
	list :latest_faculties, maxlength: 20, marshal: true
	list :latest_ideas, maxlength: 20, marshal: true

	#Counters
	counter :followers_counter
	counter :students_counter
	counter :ideas_counter

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

  def name_badge
  	words = name.split(' ')
  	words.map{|w| w.first }.join
  end

  def rebuild_cache
    UpdateSchoolCacheJob.perform_later(id)
  end

	private

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
