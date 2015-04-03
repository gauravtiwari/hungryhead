class Meta < ActiveRecord::Base
  
  #Includes Modules
  extend FriendlyId
  friendly_id :slug_candidates

  acts_as_taggable_on :markets, :locations, :technologies

  #Upload logos and covers
  mount_uploader :logo, LogoUploader
  mount_uploader :cover, CoverUploader

  #CallBack hooks
  after_save :create_slug
  
  #Associations
  belongs_to :user
  has_many :slugs, as: :sluggable, dependent: :destroy
  
  acts_as_followable
  acts_as_commentable


  #Store accessor for JSON columns
  store_accessor :profile, :locations, :markets, :facebook_url, :twitter_url, :website
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

  def find_founders
    User.find(founders)
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

end
