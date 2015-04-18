class Vote < ActsAsVotable::Vote

  after_create :increment_counters
  before_destroy :decrement_counters

  def increment_counters
    votable.votes_counter.increment
    votable.voters_ids << voter_id
  end

  def decrement_counters
    votable.votes_counter.decrement
    votable.voters_ids.delete(voter_id)
  end

end
