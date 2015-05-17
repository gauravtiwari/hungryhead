class Idea < ActiveRecord::Base

  include IdentityCache

  include Rails.application.routes.url_helpers
  #included modules
  include Redis::Objects
  #return objects in same order as specificied
  extend OrderAsSpecified

  #Gamification
  has_merit

  extend FriendlyId
  friendly_id :slug_candidates

  #Includes concerns
  include Sluggable
  include Commentable
  include Votable
  include Followable
  include Sharings
  include Activist
  include Scorable
  include Investable
  include Feedbackable

  #CallBack hooks
  before_destroy :decrement_counters, :remove_from_soulmate, :delete_activity
  before_create :add_fund
  after_save :load_into_soulmate

  acts_as_taggable_on :markets, :locations, :technologies

  #Cache ids of followers, voters, sharers, feedbackers, investors and activities
  set :followers_ids
  list :voters_ids
  list :sharers_ids
  list :feedbackers_ids
  list :investors_ids
  list :commenters_ids

  #Set to store trending
  list :latest, maxlength: 20, marshal: true, global: true

  #Store latest idea notifications
  sorted_set :ticker, maxlength: 100, marshal: true

  #Leaderboard ideas
  sorted_set :leaderboard, global: true
  sorted_set :trending, global: true

  #Redis Cache counters
  counter :followers_counter
  counter :investors_counter
  counter :feedbackers_counter
  counter :views_counter
  counter :votes_counter
  counter :shares_counter
  counter :comments_counter

  #Enumerators for handling states
  enum status: { draft:0, published:1, reviewed:2 }
  enum privacy: { me:0, everyone:2 }

  #Scopes
  scope :published_ideas, -> { where(status: 1) }
  scope :for_user, lambda {|user| where("student_id=? OR team_ids @> ?", "#{user.id}", "{#{user.id}}") }

  #Upload logos and covers
  mount_uploader :logo, LogoUploader
  mount_uploader :cover, CoverUploader

  #Associations
  belongs_to :student, touch: true
  belongs_to :school
  has_many :idea_messages, dependent: :destroy


  #Model caching indexing
  cache_index :slug
  cache_index :sash_id
  cache_index :level
  cache_index :school_id
  cache_index :student_id

  #Model caching embeds
  cache_has_many :followers, :inverse_name => :followable, :embed => true
  cache_has_many :feedbacks, :embed => true
  cache_has_many :investments, :embed => true

  #Includes modules
  has_paper_trail :only => [:name, :description, :elevator_pitch,
    :high_concept_pitch, :sections]

  #Store accessor for JSON columns
  store_accessor :fund, :balance

  store_accessor :settings, :visible_everyone

  store_accessor :profile, :locations, :markets, :facebook_url, :twitter_url,
  :website

  store_accessor :media, :logo_position, :logo_processing,
  :cover_position, :cover_processing

  store_accessor :sections, :video, :video_html, :market, :problems, :solutions, :vision, :value_proposition

  #Auto HTML for youtube video
  auto_html_for :video do
    html_escape
    vimeo(:width => 640, :height => 250, :autoplay => false)
    youtube(:width => 640, :height => 250, :autoplay => false)
    simple_format
  end

  #Validations

  validates :name, :presence => true, :uniqueness => {:case_sensitive => false }
  validates :high_concept_pitch, :presence => true, length: {within: 20..50}
  validates :elevator_pitch, :presence => true, length: {within: 50..140}

  public

  def can_score?
    true
  end

  def founder?(user)
    student == user
  end

  def name_badge
    (name_split.first + name_split.second).upcase
  end

  def user_name
    user ? user.name : ''
  end

  def name_split
    name.split('')
  end

  def is_owner?(current_user)
    student == current_user
  end

  def in_team?(user)
    founder?(user) || team_ids.include?(user.id.to_s)
  end

  def invited?(user)
    team_invites_ids.include?(user.id.to_s)
  end

  def add_fund
    self.fund = {"balance" => 0}
  end

  def profile_complete?
    if [self.name, self.high_concept_pitch, self.elevator_pitch,
      self.description, self.market, self.solutions, self.problems,
      self.value_proposition].any?{|f| f.blank? }
      return false
    else
      return true
    end
  end

  def visible?
    published? && everyone?
  end

  def rebuild_cache?
    slug_changed? || name_changed? || high_concept_pitch_changed? && !id_changed?
  end

  private

  def load_into_soulmate
    if visible?
      loader = Soulmate::Loader.new("ideas")
      loader.add("term" => name, "description" => high_concept_pitch, "id" => id, "data" => {
        "link" => idea_path(self)
        })
    else
      remove_from_soulmate
    end
  end

  def remove_from_soulmate
    loader = Soulmate::Loader.new("ideas")
    loader.remove("id" => id)
  end

  def slug_candidates
    [:name]
  end

  def decrement_counters
    #Decrement counters for student and school
    school.ideas_counter.decrement
    student.ideas_counter.decrement
    #Remove self from cached list
    student.latest_ideas.delete(id)
    school.latest_ideas.delete(id)
    #Remove self from sorted set
    Idea.latest.delete(id)
    Idea.trending.delete(id)
    Idea.leaderboard.delete(id)
  end

  def delete_activity
    #Delete idea time from user feed
    DeleteUserFeedJob.set(wait: 5.seconds).perform_later(self.id, self.class.to_s)
  end

end
