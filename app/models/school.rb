class School < ActiveRecord::Base

	include Followable
	include Sluggable

	has_many :users, as: :students
	has_many :ideas

	store_accessor :data, :established, :location, :website
	store_accessor :media, :logo_position,
	:cover_position, :cover_prcessing, :logo_processing

	#Redis Cache counters and ids
	include Redis::Objects
	sorted_set :followers_ids
	sorted_set :students_ids
	sorted_set :ideas_ids
	sorted_set :activities_ids

	#Counters
	counter :followers_counter
	counter :students_counter
	counter :ideas_counter

	#Mount carrierwave
	mount_uploader :logo, LogoUploader
	mount_uploader :cover, CoverUploader

	validates :name, :presence => true,
	:on => :create

	def slug_candidates
	 [:name]
	end

	after_save :load_into_soulmate
  before_destroy :remove_from_soulmate

	private

	def short_name
		words = name.split(' ')
		name = ""
		words.map{|w| w.first.upcase }.join(" ")
	end

	def load_into_soulmate
		loader = Soulmate::Loader.new("schools")
		if logo
		  image =  logo.url(:avatar)
		  resume = location
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
