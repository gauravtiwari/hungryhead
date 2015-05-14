module Voter

  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :voter, :dependent => :destroy
  end

  def count_votes(votable)
    votes.where(voter: self, votable: votable).count
  end

end