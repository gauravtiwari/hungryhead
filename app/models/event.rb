class Event < ActiveRecord::Base

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

  enum status: { closed:0, open:1 }

  belongs_to :eventable, polymorphic: true

end
