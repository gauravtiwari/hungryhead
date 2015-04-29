class School < ActiveRecord::Base

	include IdentityCache
	include Followable
	include Sluggable

	has_many :students, as: :student, class_name: 'Student'
	has_many :teachers, as: :teacher, class_name: 'Teacher'
	has_many :ideas

	acts_as_taggable_on :locations

	store_accessor :data, :established, :locations, :website
	store_accessor :media, :logo_position,
	:cover_position, :cover_prcessing, :logo_processing

	#Counters
	counter :followers_counter
	counter :students_counter
	counter :ideas_counter

	#Caching Model
	cache_has_many :follows, :inverse_name => :followable, :embed => true
	cache_has_many :students, :embed => true
	cache_has_many :teachers, :embed => true
	cache_has_many :ideas, :embed => true

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
