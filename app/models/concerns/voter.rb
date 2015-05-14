module Voter

  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :voter, :dependent => :destroy
  end

  def count_idea_votes
    votes.where(voter: self, votable_type: 'Idea').count
  end

end