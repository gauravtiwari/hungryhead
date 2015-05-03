class Idea < ActiveRecord::Base

  #included modules
  include IdentityCache
  include Redis::Objects
  include Rails.application.routes.url_helpers

  #Includes concerns
  include Commentable
  include Votable
  include Followable
  include Sluggable
  include Sharings
  include Activist

  acts_as_taggable_on :markets, :locations, :technologies

  #Cache ids of followers, voters, sharers, feedbackers, investors and activities
  list :followers_ids
  list :voters_ids
  list :sharers_ids
  list :feedbackers_ids
  list :investors_ids
  list :commenters_ids

  #Set to store trending and popular ideas
  sorted_set :trending, global: true
  sorted_set :popular, global: true
  list :latest, maxlength: 20, marshal: true, global: true

  #Store latest idea notifications
  sorted_set :latest_notifications, maxlength: 100, marshal: true

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

  #CallBack hooks
  before_destroy :decrement_counters, :remove_from_soulmate, :delete_activity
  before_create :add_fund
  after_commit :increment_counters, on: :create
  after_save :load_into_soulmate

  #Associations
  belongs_to :student, touch: true
  belongs_to :school

  #Rest of the assocuations
  has_many :feedbacks, dependent: :destroy
  has_many :idea_messages, dependent: :destroy
  has_many :investments, dependent: :destroy
  has_many :slugs, as: :sluggable, dependent: :destroy

  #Caching Model
  cache_has_many :feedbacks, :embed => true
  cache_has_many :investments, :embed => true
  cache_has_many :followers, :inverse_name => :followable, :embed => true
  cache_has_many :votes, :inverse_name => :votable, :embed => true
  cache_has_many :comments, :inverse_name => :commentable, embed: true
  cache_has_many :shares, :inverse_name => :shareable, embed: true
  cache_has_many :idea_messages, :embed => true

  cache_index :school_id
  cache_index :slug

  #Includes modules
  has_merit
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
    name_split.first + name_split.second
  end

  def user_name
    user ? user.name : ''
  end

  def name_split
    name.split('')
  end

  def invested?(user)
    investors_ids.values.include?(user.id.to_s)
  end

  def feedbacked?(user)
    feedbackers_ids.values.include?(user.id.to_s)
  end

  def is_owner?(current_user)
    student == current_user
  end

  def can_invest?(user)
    student.balance > 10 && !invested?(user)
  end

  def in_team?(user)
    founder?(user) || team_ids.include?(user.id.to_s)
  end

  def invited?(user)
    team_invites_ids.include? user.id.to_s
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

  private

  def load_into_soulmate
    if published? && everyone?
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
    [:name, [:name, :id]]
  end

  def increment_counters
    school.ideas_counter.increment if student.type == "Student"
    student.ideas_counter.increment if student.type == "Student"
    student.ideas_ids <<  id if student.type == "Student"
    Idea.latest << idea_json
    Idea.popular.add(id, 0)
    Idea.trending.add(id, 0)
  end

  def decrement_counters
    school.ideas_counter.decrement if student.type == "Student"
    student.ideas_counter.decrement if student.type == "Student"
    student.ideas_ids.delete(id) if student.type == "Student"
    Idea.latest.delete(idea_json)
    Idea.popular.delete(id)
    Idea.trending.delete(id)
  end

  def idea_json
    {
      id: id,
      name: name,
      pitch: high_concept_pitch,
      url: idea_path(self)
    }
  end

  def delete_activity
    DeleteUserFeedJob.perform_later(self.id, self.class.to_s)
  end

end
