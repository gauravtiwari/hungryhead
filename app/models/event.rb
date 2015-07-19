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

  store_accessor :media, :cover_position, :cover_left,
  :cover_processing, :cover_tmp

  list :attendees_ids
  list :invites_ids
  counter :attendees_counter
  counter :invites_counter

  #Mount carrierwave
  mount_uploader :cover, CoverUploader

  #Tags for feedback
  acts_as_taggable_on :categories

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

  def name_badge
    (title.split('').first + title.split('').second).upcase
  end

  def invited?(user)
    invites_ids.include?(user.id.to_s)
  end

  def slug_candidates
   [:title]
  end

  private

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end

end
