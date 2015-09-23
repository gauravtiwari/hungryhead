class Event < ActiveRecord::Base

  #included modules
  include Redis::Objects
  include ActiveModel::Validations

  #Callbacks
  before_destroy  :delete_activity

  #Slug
  extend FriendlyId
  friendly_id :slug_candidates

  #Geocode
  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude
  after_validation :geocode, if: ->(event){ event.address.present? and event.address_changed? }

  #Validation
  validates :title, :presence => true, length: {within: 10..50}
  validates :start_time, :end_time, :presence => true
  validates :excerpt, :presence => true, length: {within: 100..300}
  validates :address, :presence => true

  #Includes concerns
  include Sluggable
  include Commentable
  include Votable
  include Impressionable

  #JSONB store accessor
  store_accessor :media, :cover_position, :cover_left,
  :cover_processing, :cover_tmp

  #Enumerators for handling states
  enum status: { draft:0, published:1 }
  enum privacy: { me: 0, friends: 1, everyone: 2 }

  #Redis Lists
  list :attendees_ids
  list :commenters_ids
  counter :attendees_counter
  counter :comments_counter

  #Mount carrierwave
  mount_uploader :cover, CoverUploader

  #Tags for feedback
  acts_as_taggable_on :categories

  #Associations
  belongs_to :user, polymorphic: true, touch: true
  has_many :event_attendees

  public

  def attending?(user)
    attendees_ids.include?(user.id.to_s)
  end

  def get_attendees
    User.find(attendees_ids.values)
  end

  def name_badge
    (title.split('').first + title.split('').second).upcase
  end

  def profile_complete?
    if [self.title, self.description, self.cover,
      self.excerpt, self.space, self.address].any?{|f| f.blank? }
      return false
    else
      return true
    end
  end

  private

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end

  def slug_candidates
   [:title]
  end

  def delete_activity
    #Delete activity item from feed
    Activity.where(trackable_id: self.id, trackable_type: self.class.to_s).each do |activity|
      #Delete cached activities
      DeleteNotificationCacheService.new(activity).delete
      #finally destroy the activity
      activity.destroy if activity.present?
    end
  end

end
