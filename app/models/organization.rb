class Organization < ActiveRecord::Base

  include Followable
  include Sluggable

  store_accessor :media, :logo_position,
  :cover_position, :cover_prcessing, :logo_processing

  mount_uploader :logo, LogoUploader
  mount_uploader :cover, CoverUploader

  validates :name, :presence => true,
    :on => :create

	def slug_candidates
	 [:name]
	end

  def short_name
    words = name.split(' ')
    name = ""
    words.map{|w| w.first.upcase }.join(" ")
  end

end
