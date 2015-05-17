module Sluggable

  extend ActiveSupport::Concern

  included do
    extend FriendlyId
    friendly_id :slug_candidates
    has_many :slugs, as: :sluggable, dependent: :destroy
    after_save :create_slug
  end

  private

  def create_slug
    return if slug == slugs.last.try(:slug)
    previous = slugs.where('lower(slug) = ?', slug.downcase)
    previous.delete_all
    slugs.create!(slug: slug)
  end

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end

end