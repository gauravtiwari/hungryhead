class Event < ActiveRecord::Base

  #included modules
  include Redis::Objects

  #Slug
  extend FriendlyId
  friendly_id :slug_candidates
  #Geocode
  geocoded_by :address
  after_validation :geocode, if: ->(event){ event.address.present? and event.address_changed? }

  validates :title, :presence => true, length: {within: 10..50}
  validates :start_time, :end_time, :presence => true
  validates :excerpt, :presence => true, length: {within: 100..300}
  validates :description, :presence => true, length: {within: 300..2000}

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
  counter :comments_counter

  #Mount carrierwave
  mount_uploader :cover, CoverUploader

  #Tags for feedback
  acts_as_taggable_on :categories

  belongs_to :owner, polymorphic: true, touch: true
  has_many :event_attendees
  has_many :event_invites

  after_destroy  :delete_activity
  after_commit :create_activity, on: :create

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

  def create_activity
    # Enque activity creation
    CreateActivityJob.perform_later(id, self.class.to_s) if Activity.where(trackable: self).empty?
  end

  def delete_activity
    #Delete activity item from feed
    DeleteActivityJob.perform_later(self.id, self.class.to_s)
  end

end
