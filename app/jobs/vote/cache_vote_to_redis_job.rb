class CacheVoteToRedisJob < ActiveJob::Base

  def perform(votable_id, votable_type)
    @votable = votable_type.constantize.fetch(votable_id)
    #Reset counter and voters_ids
    @votable.votes_counter.reset
    @votable.voters_ids.clear
    #Increment count by votes
    @votable.votes_counter.incr(@votable.fetch_votes.count)
    #Cache voters into redis
    @votable.voters_ids << @votable.fetch_votes.pluck(:voter_id)
  end

end