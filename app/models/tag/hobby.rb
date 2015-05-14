class Hobby < ActiveRecord::Base

  extend FriendlyId
  friendly_id :slug_candidates
  include Sluggable

  private
  def slug_candidates
    [:name]
  end
end