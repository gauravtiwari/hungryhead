class Event < ActiveRecord::Base

  extend FriendlyId
  friendly_id :slug_candidates

  include Sluggable
  include Commentable
  include Votable

  belongs_to :eventable, polymorphic: true
end
