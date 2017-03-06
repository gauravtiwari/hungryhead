class Idea < ActiveRecord::Base
  extend OrderAsSpecified
  include Rails.application.routes.url_helpers

  include Redis::Objects

  extend FriendlyId
  friendly_id :slug_candidates

  before_destroy :decrement_counters, :remove_from_soulmate, :delete_activity
  before_create :add_fund
  after_save(:soulmate_loader, if: :visible?) && :rebuild_cache?

  has_merit

  include Sluggable
  include Votable
  include Followable
  include Activist
  include Scorable
  include Investable
  include Feedbackable
  include Impressionable

  acts_as_taggable_on :markets, :technologies

  list :voters_ids
  list :feedbackers_ids
  list :investors_ids
  set :impressioners_ids

  sorted_set :latest, global: true
  sorted_set :leaderboard, global: true
  sorted_set :trending, global: true

  counter :investors_counter
  counter :feedbackers_counter
  counter :views_counter
  counter :votes_counter
  counter :idea_messages_counter

  enum status: { draft: 0, published: 1 }
  enum privacy: { team: 0, everyone: 1 }

  scope :published, -> { where(status: 1) }
  scope :from_school, ->(school_id) { where(status: 1, school_id: school_id) }
  scope :public_ideas, -> { where(privacy: 1) }
  scope :for_user, lambda { |user| where('user_id=? OR team_ids @> ?', user.id.to_s, "{#{user.id}}") }

  belongs_to :user, touch: true
  belongs_to :school, touch: true
  has_many :idea_messages, dependent: :destroy
  has_many :team_invites, dependent: :destroy

  has_paper_trail on: [:update, :destroy],
                  only: [:name, :description, :elevator_pitch, :high_concept_pitch]

  store_accessor :fund, :balance

  store_accessor :settings, :visible_everyone

  store_accessor :profile, :markets, :facebook_url, :twitter_url,
                 :website

  store_accessor :media, :logo_position, :cover_position,
                 :cover_left, :cover_processing, :logo_processing, :logo_tmp, :cover_tmp

  mount_uploader :logo, LogoUploader
  mount_uploader :cover, CoverUploader

  auto_html_for :video do
    html_escape
    vimeo(width: 640, height: 250, autoplay: false)
    youtube(width: 640, height: 250, autoplay: false)
    simple_format
  end

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :logo,
            file_size: {
              maximum: 1.megabytes.to_i
            }
  validates :cover,
            file_size: {
              maximum: 1.megabytes.to_i
            }
  validates :high_concept_pitch, presence: true, length: { within: 20..50 }
  validates :elevator_pitch, presence: true, length: { within: 100..140 }

  public

  def get_published_feedbacks
    feedbacks.order(created_at: :desc)
  end

  def contributers
    (investors_ids.values + feedbackers_ids.values + voters_ids.values).uniq
  end

  def card_json
    {
      id: uuid,
      name: name,
      name_badge: name_badge,
      updated_at: updated_at,
      url: idea_path(self),
      description: high_concept_pitch
    }
  end

  def get_investments
    investments.order(created_at: :desc)
  end

  def get_idea_messages
    idea_messages.order(created_at: :desc)
  end

  def founder?(current_user)
    user == current_user
  end

  def get_avatar
    logo.url(:avatar)
  end

  def avatar_present?
    logo.url(:avatar).present?
  end

  def name_badge
    (name.split('').first + name.split('').second).upcase
  end

  def user_name
    user ? user.name : ''
  end

  def name_split
    name.split('')
  end

  def is_owner?(current_user)
    user == current_user
  end

  def in_team?(user)
    founder?(user) || team_ids.include?(user.id.to_s)
  end

  def team_member?(user)
    team_ids.include?(user.id.to_s)
  end

  def invited?(user)
    team_invites_ids.include?(user.id.to_s)
  end

  def get_team
    ids = team_ids.push(user_id.to_s)
    User.find(ids)
  end

  def add_fund
    self.fund = { 'balance' => 0 }
  end

  def profile_complete?
    if [name, high_concept_pitch, elevator_pitch,
        description].any?(&:blank?)
      false
    else
      true
    end
  end

  def visible?
    published? && everyone?
  end

  def rebuild_cache?
    slug_changed? || name_changed? || high_concept_pitch_changed? && !id_changed?
  end

  private

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end

  def soulmate_loader
    RecordSavedJob.set(wait: 1.minute).perform_later(id, self.class.to_s)
  end

  def remove_from_soulmate
    loader = Soulmate::Loader.new('ideas')
    loader.remove('id' => id)
    true
  end

  def slug_candidates
    [:name]
  end

  def decrement_counters
    school.ideas_counter.reset if school_id.present?
    if school_id.present?
      school.ideas_counter.incr(
        Idea.from_school(school_id).size
      )
    end
    user.ideas_counter.reset
    user.ideas_counter.incr(user.ideas.size)

    Idea.latest.delete(id)
    Idea.trending.delete(id)
    Idea.leaderboard.delete(id)
    true
  end

  def delete_activity
    Activity.where(
      trackable_id: id,
      trackable_type: self.class.to_s
    ).each do |activity|
      DeleteNotificationCacheService.new(activity).delete
      activity.destroy if activity.present?
    end
  end
end
