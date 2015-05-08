module Votable

  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, :dependent => :destroy
    cache_has_many :votes, :inverse_name => :votable, :embed => true
    list :voters_ids
    counter :votes_counter
  end

  def voted?(user)
    voters_ids.values.include?(user.id.to_s)
  end

  def find_voters
    User.where(id: voters_ids.values)
  end

end