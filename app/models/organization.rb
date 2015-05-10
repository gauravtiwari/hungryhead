class Organization < ActiveRecord::Base

  include Redis::Objects

  #Included concerns
  include Followable
  include Sluggable

  acts_as_taggable_on :locations
  store_accessor :data, :established, :locations, :website
  store_accessor :media, :logo_position,
  :cover_position, :cover_left, :cover_prcessing, :logo_processing

  #Redis Cache counters and ids
  set :followers_ids
  #Counters
  counter :followers_counter

  mount_uploader :logo, LogoUploader
  mount_uploader :cover, CoverUploader

  #Callbacks hooks
  after_save :load_into_soulmate
  before_destroy :remove_from_soulmate

  validates :name, :presence => true,
    :on => :create

	def slug_candidates
	 [:name]
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
        }
      )
  end

  def remove_from_soulmate
    loader = Soulmate::Loader.new("universities")
    loader.remove("id" => id)
  end

end
