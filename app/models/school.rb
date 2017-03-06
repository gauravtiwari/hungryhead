class School < ActiveRecord::Base
  include Redis::Objects

  after_save :load_into_soulmate
  before_destroy :remove_from_soulmate

  include Followable
  include Sharings
  include Feeder
  include Sluggable
  include Eventable

  has_many :students, -> { where(state: 1, role: 1) }, class_name: 'User'
  has_many :ideas, -> { where(status: 1, privacy: 1) }, class_name: 'Idea'
  has_many :faculties, -> { where(state: 1, role: 4) }, class_name: 'User'
  has_many :users, -> { where(state: 1) }, class_name: 'User'
  has_many :school_admins
  belongs_to :user, class_name: 'User'

  acts_as_taggable_on :locations

  store_accessor :media, :logo_position, :logo_tmp, :cover_tmp,
                 :cover_position, :cover_left, :cover_prcessing, :logo_processing

  set :followers_ids

  counter :followers_counter
  counter :people_counter
  counter :ideas_counter

  mount_uploader :logo, LogoUploader
  mount_uploader :cover, CoverUploader

  validates :name, presence: true, on: :create
  validates :logo,
            file_size: {
              maximum: 1.megabytes.to_i
            }
  validates :cover,
            file_size: {
              maximum: 1.megabytes.to_i
            }

  def slug_candidates
    [:name]
  end

  def get_published_faculties
    faculties.order(created_at: :desc)
  end

  def get_published_users
    users.order(created_at: :desc)
  end

  def get_avatar
    logo.url(:avatar)
  end

  def avatar_present?
    logo.url(:avatar).present?
  end

  def get_published_ideas
    ideas.order(created_at: :desc)
  end

  def get_published_events
    events.order(created_at: :desc)
  end

  def get_published_students
    students.order(created_at: :desc)
  end

  def name_badge
    words = name.split(' ')
    words.first(3).map(&:first).join.upcase
  end

  # TODO: delete cache keys
  def ideas_cache_key
    count = ideas.published.count
    max_updated_at = ideas.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "school_ideas/all-#{count}-#{max_updated_at}"
  end

  def people_cache_key
    count = users.count
    max_updated_at = users.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "school_people/all-#{count}-#{max_updated_at}"
  end

  private

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end

  def load_into_soulmate
    loader = Soulmate::Loader.new('schools')
    loader.add(
      'term' => name,
      'name_badge' => name_badge,
      'image' => logo.url(:avatar),
      'description' => location_list,
      'id' => id,
      'data' => {
        'link' => Rails.application.routes.url_helpers.profile_path(self)
      }
    )
  end

  def remove_from_soulmate
    loader = Soulmate::Loader.new('universities')
    loader.remove('id' => id)
    true
  end
end
