class Event < ActiveRecord::Base
  include Redis::Objects
  include ActiveModel::Validations

  before_destroy  :delete_activity

  extend FriendlyId
  friendly_id :slug_candidates

  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude
  after_validation :geocode, if: ->(event){ event.address.present? and event.address_changed? }

  validates :title, :presence => true, length: {within: 10..50}
  validates :start_time, :end_time, :presence => true
  validates :excerpt, :presence => true, length: {within: 100..300}
  validates :address, :presence => true

  include Sluggable
  include Commentable
  include Votable
  include Impressionable

  store_accessor :media, :cover_position, :cover_left,
  :cover_processing, :cover_tmp

  enum status: { draft:0, published:1 }
  enum privacy: { me: 0, friends: 1, everyone: 2 }

  list :attendees_ids
  list :commenters_ids
  counter :attendees_counter
  counter :comments_counter

  mount_uploader :cover, CoverUploader

  acts_as_taggable_on :categories

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
    Activity.where(
      trackable_id: self.id,
      trackable_type: self.class.to_s
    ).each do |activity|
      DeleteNotificationCacheService.new(activity).delete
      activity.destroy if activity.present?
    end
  end

end
