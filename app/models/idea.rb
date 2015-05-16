class Idea < ActiveRecord::Base

  #Publish events via wisper
  include Wisper::Publisher

  #return objects in same order as specificied
  extend OrderAsSpecified

  #Includes concerns
  include Commentable
  include Votable
  include Followable
  include Sharings
  include Activist
  include Scorable
  include Investable
  include Feedbackable
  include Sluggable

  #Store after_destroy actions and redis objects fields
  include IdeaConcerns

  after_create do |idea|
    #increment counters
    broadcast(:record_created, idea)
  end

  after_save do |idea|
    #rebuild slug
    broadcast(:sluggable_saved, idea)
  end

  #CallBack hooks
  before_save :add_fund

  #Scopes
  scope :published_ideas, -> { where(status: 1) }
  scope :for_user, lambda {|user| where("student_id=? OR team_ids @> ?", "#{user.id}", "{#{user.id}}") }

  #Upload logos and covers
  mount_uploader :logo, LogoUploader
  mount_uploader :cover, CoverUploader

  #Associations
  belongs_to :student, touch: true
  belongs_to :school

  #Rest of the assocuations
  has_many :idea_messages, dependent: :destroy

  has_merit
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

  private


  def slug_candidates
    [:name]
  end

end
