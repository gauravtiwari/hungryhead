class Event < ActiveRecord::Base

  #included modules
  include Redis::Objects

  extend FriendlyId
  friendly_id :slug_candidates

  include Sluggable
  include Commentable
  include Votable

  list :attendees_ids
  counter :attendees_counter

  belongs_to :eventable, polymorphic: true

end
