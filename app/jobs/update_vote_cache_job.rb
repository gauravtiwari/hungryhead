class UpdateVoteCacheJob < ActiveJob::Base

  #JOB to rebuild cache for votables
  def perform(votable_id, votable_type)
    @votable = votable_type.safe_constantize.find(votable_id)
    @votable.votes_counter.reset
    @votable.voters_ids.clear
    @votable.votes_counter.incr(@votable.votes.size)
    @votable.votes.find_each do |vote|
      vote.votable.voters_ids.add(vote.voter.id)
    end
  end
end