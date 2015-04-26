class Idea < ActiveRecord::Base

  #Includes Modules
  include Redis::Objects

  #Includes concerns
  include Commentable
  include Votable
  include Followable
  include Sluggable
  include Sharings

  acts_as_taggable_on :markets, :locations, :technologies
  acts_as_punchable

  #Cache ids of followers, voters, sharers, feedbackers, investors and activities
  sorted_set :followers_ids
  sorted_set :voters_ids
  sorted_set :sharers_ids
  sorted_set :feedbackers_ids
  sorted_set :investors_ids
  sorted_set :commenters_ids
  sorted_set :latest_activities, maxlength: 100, marshal: true

  #Calculate idea popularity and trending score
  sorted_set :trending_list, maxlength: 20, marshal: true
  sorted_set :popular_list, maxlength: 20, marshal: true

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
  scope :for_user, lambda {|user| where("student_id=? OR team @> ?", "#{user.id}", "{#{user.id}}") }

  #Upload logos and covers
  mount_uploader :logo, LogoUploader
  mount_uploader :cover, CoverUploader

  #CallBack hooks
  before_destroy :decrement_counters, :remove_from_soulmate
  before_create :add_fund, :increment_counters
  after_save :load_into_soulmate

  #Associations
  belongs_to :student, touch: true
  belongs_to :school

  #Rest of the assocuations
  has_many :feedbacks, dependent: :destroy, autosave: true
  has_many :idea_messages, dependent: :destroy, autosave: true
  has_many :investments, dependent: :destroy, autosave: true
  has_many :slugs, as: :sluggable, dependent: :destroy

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

  def has_invested?(user)
    !investors.include? user.id.to_s
  end

  def can_feedback?(user)
    !feedbackers.include? user.id.to_s
  end

  def find_feedbackers
    User.find(feedbackers)
  end

  def find_investors
    User.find(investors)
  end

  def find_team
    User.find(team)
  end

  def is_owner?(current_user)
    student == current_user
  end

  def can_invest?(user)
    student.balance > 10 && has_invested?(user)
  end

  def in_team?(user)
    founder?(user) || team.include?(user.id.to_s)
  end

  def invited?(user)
    team_invites.include? user.id.to_s
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
        "link" => Rails.application.routes.url_helpers.idea_path(self)
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
    school.ideas_counter.increment
    student.ideas_counter.increment
  end

  def decrement_counters
    school.ideas_counter.decrement
    student.ideas_counter.decrement
  end

end
