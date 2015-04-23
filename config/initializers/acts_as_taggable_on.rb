ActsAsTaggableOn::Tag.class_eval do
  has_many :slugs, as: :sluggable, dependent: :destroy
  extend FriendlyId
  friendly_id :slug_candidates
  def slug_candidates
    [:name]
  end

  after_save :create_slug

  private

  def create_slug
    becomes(Tag).create_slug
  end

end