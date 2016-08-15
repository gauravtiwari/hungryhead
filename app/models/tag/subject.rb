class Subject < ActiveRecord::Base
  include Sluggable

  private

  def slug_candidates
    [:name]
  end

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end
end
