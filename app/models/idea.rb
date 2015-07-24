class Idea < ActiveRecord::Base

  extend OrderAsSpecified

  include Rails.application.routes.url_helpers
  #included modules
  include Redis::Objects
  #Gamification
  has_merit

  extend FriendlyId
  friendly_id :slug_candidates

  #Includes concerns
  include Sluggable
  include Commentable
  include Votable
  include Followable
  include Activist
  include Scorable
  include Investable
  include Feedbackable
  include Impressionable

  #CallBack hooks
  after_destroy :decrement_counters, :remove_from_soulmate, :delete_activity
  before_create :add_fund
  after_save :load_into_soulmate, if: :visible?

  acts_as_taggable_on :markets, :locations, :technologies

  #Cache ids of voters, feedbackers, investors and activities
  list :voters_ids
  list :feedbackers_ids
  list :investors_ids
  list :commenters_ids
  set :impressioners_ids

  #Store latest idea notifications
  sorted_set :ticker, marshal: true

  #Leaderboard ideas
  sorted_set :latest, global: true
  sorted_set :leaderboard, global: true
  sorted_set :trending, global: true

  #Redis Cache counters
  counter :investors_counter
  counter :feedbackers_counter
  counter :views_counter
  counter :votes_counter
  counter :comments_counter
  counter :idea_messages_counter

  #Enumerators for handling states
  enum status: { draft:0, published:1 }
  enum privacy: { team: 0, everyone: 1 }

  #Scopes
  scope :published, -> { where(status: 1) }
  scope :from_school, ->(school_id) { where(status: 1, :school_id => school_id)}
  scope :public_ideas, -> { where(privacy: 1) }
  scope :for_user, lambda {|user| where("user_id=? OR team_ids @> ?", "#{user.id}", "{#{user.id}}") }

  #Associations
  belongs_to :user, touch: true
  belongs_to :school, touch: true
  has_many :idea_messages, dependent: :destroy
  has_many :team_invites, dependent: :destroy

  #Includes modules
  has_paper_trail :on => [:update, :destroy], :only => [:name, :description, :elevator_pitch,
    :high_concept_pitch, :video, :video_html, :market, :problems,
  :solutions, :vision, :value_proposition, :business_model]

  #Store accessor for JSON columns
  store_accessor :fund, :balance

  store_accessor :settings, :visible_everyone

  store_accessor :components, {}

  store_accessor :profile, :locations, :markets, :facebook_url, :twitter_url,
  :website

  store_accessor :media, :logo_position, :cover_position,
  :cover_left, :cover_processing, :logo_processing, :logo_tmp, :cover_tmp

  #Upload logos and covers
  mount_uploader :logo, LogoUploader
  mount_uploader :cover, CoverUploader

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
  validates :elevator_pitch, :presence => true, length: {within: 100..140}

  public

  def can_score?
    true
  end

  def get_published_feedbacks
    feedbacks.order(created_at: :desc)
  end

  def card_json
    {
      id: uuid,
      name: name,
      name_badge: name_badge,
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

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end

  def load_into_soulmate
    if visible?
      loader = Soulmate::Loader.new("ideas")
      loader.add("term" => name, "description" => high_concept_pitch, "id" => id, "data" => {
        "link" => idea_path(slug)
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
    #Decrement counters for user and school
    school.ideas_counter.reset
    school.ideas_counter.(Idea.from_school(school_id).size)
    user.ideas_counter.reset
    user.ideas_counter.(user.ideas.size)

    #Remove self from sorted set
    Idea.latest.delete(id)
    Idea.trending.delete(id)
    Idea.leaderboard.delete(id)
  end

  def delete_activity
    #Delete idea time from user feed
    DeleteActivityJob.perform_later(self.id, self.class.to_s)
  end

end
