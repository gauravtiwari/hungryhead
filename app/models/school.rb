class School < ActiveRecord::Base
	
	has_many :users, as: :students
	has_many :ideas
	has_many :slugs, as: :sluggable, dependent: :destroy

	store_accessor :data, :established, :location, :website
	store_accessor :media, :logo_position,
	:cover_position, :cover_prcessing, :logo_processing
	
	acts_as_followable
	include Redis::Objects

	list :followers_ids
	list :students_ids
	list :ideas_ids
	counter :followers_counter
	counter :students_counter
	counter :ideas_counter
	sorted_set :activities_ids

	mount_uploader :logo, LogoUploader
	mount_uploader :cover, CoverUploader

	extend FriendlyId

	
	friendly_id :slug_candidates

	validates :name, :presence => true,
	:on => :create

	def slug_candidates
	 [:name]
	end

	def should_generate_new_friendly_id?
	slug.blank? || name_changed?
	end

	after_save :create_slug
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

	def create_slug
		return if !slug_changed? || slug == slugs.last.try(:slug)
		#re-use old slugs
		previous = slugs.where('lower(slug) = ?', slug.downcase)
		previous.delete_all
		slugs.create!(slug: slug)
	end
end
