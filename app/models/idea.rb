class Idea < ActiveRecord::Base

  #Includes Modules
  extend FriendlyId
  include PublicActivity::Model
  friendly_id :slug_candidates

  acts_as_taggable_on :markets, :locations, :technologies

  #Enumerators for handling states
  enum status: { draft:0, published:1, reviewed:2 }
  enum privacy: { me:0, everyone:2 }

  #Scopes
  scope :published_ideas, -> { where(status: 1) }
  scope :for_user, lambda {|user| where("team @> ?", "{#{user.id}}") }

  #Upload logos and covers
  mount_uploader :logo, LogoUploader
  mount_uploader :cover, CoverUploader

  #CallBack hooks
  before_destroy :remove_activity
  before_create :add_fund
  after_save :create_slug
  #Associations

  belongs_to :user, counter_cache: true, touch: true
  belongs_to :school, counter_cache: true
  has_many :feedbacks, dependent: :destroy, autosave: true
  has_many :investments, dependent: :destroy, autosave: true
  has_many :shares, as: :shareable, dependent: :destroy, autosave: true
  has_many :slugs, as: :sluggable, dependent: :destroy
  
  acts_as_followable
  acts_as_votable
  acts_as_commentable
  has_merit

  #Store accessor for JSON columns
  store_accessor :fund, :balance

  store_accessor :settings, :visible_everyone

  store_accessor :profile, :locations, :markets, :facebook_url, :twitter_url, :website

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
    user == current_user
  end

  def can_invest?(user)
    user.balance > 10 && has_invested?(user)
  end

  def in_team?(user)
    team.include? user.id.to_s
  end

  def invited?(user)
    team_invites.include? user.id.to_s
  end

  def add_fund
    self.fund = {"balance" => 0}
  end

  def profile_complete?
    if [self.logo, self.name, self.high_concept_pitch, self.elevator_pitch,
      self.description, self.market, self.solutions, self.problems,
      self.vision, self.value_proposition].any?{|f| f.blank? }
      return false
    else
      return true
    end
  end

  private

  def create_slug
    return if !slug_changed? || slug == slugs.last.try(:slug)
    #re-use old slugs
    previous = slugs.where('lower(slug) = ?', slug.downcase)
    previous.delete_all
    slugs.create!(slug: slug)
  end

  def slug_candidates
    [:name, [:name, :id]]
  end

  def remove_activity
   PublicActivity::Activity.where(trackable_id: self.id, trackable_type: self.class.to_s).find_each do |activity|
    activity.destroy if activity.present?
    true
   end
  end

end
