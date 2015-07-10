class Event < ActiveRecord::Base

  include IdentityCache
  #included modules
  include Redis::Objects
  #Slug
  extend FriendlyId
  friendly_id :slug_candidates

  #Geocode
  geocoded_by :address
  after_validation :geocode, if: ->(event){ event.address.present? and event.address_changed? }

  include Sluggable
  include Commentable
  include Votable

  list :attendees_ids
  counter :attendees_counter

  belongs_to :eventable, polymorphic: true, touch: true
  has_many :attendees

  def attending?(user)
    attendees_ids.include?(user.id.to_s)
  end


end
