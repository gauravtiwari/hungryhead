class Skill < ActiveRecord::Base
  has_many :slugs, as: :sluggable, dependent: :destroy
  extend FriendlyId
  friendly_id :slug_candidates
  def slug_candidates
    [:name]
  end

  after_save :create_slug

  def create_slug
    return if !slug_changed? || slug == slugs.last.try(:slug)
    #re-use old slugs
    previous = slugs.where('lower(slug) = ?', slug.downcase)
    previous.delete_all
    slugs.create!(slug: slug)
  end
end
