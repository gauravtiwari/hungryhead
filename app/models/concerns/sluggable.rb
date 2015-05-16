module Sluggable

  extend ActiveSupport::Concern

  included do
    extend FriendlyId
    friendly_id :slug_candidates
    has_many :slugs, as: :sluggable, dependent: :destroy
  end

  private

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end

end