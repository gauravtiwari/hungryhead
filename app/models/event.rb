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
  include Impressionable

  list :attendees_ids
  list :invites_ids
  counter :attendees_counter
  counter :invites_counter

  belongs_to :owner, polymorphic: true, touch: true
  has_many :event_attendees
  has_many :event_invites

  cache_has_many :event_attendees, embed: true
  cache_has_many :event_invites, embed: true
  cache_index :slug
  cache_index :owner_id, :owner_type

  def attending?(user)
    attendees_ids.include?(user.id.to_s)
  end

  def invited?(user)
    invites_ids.include?(user.id.to_s)
  end

end
