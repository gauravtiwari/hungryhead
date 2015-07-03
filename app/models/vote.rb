class Vote < ActiveRecord::Base

  #Model Associations
  belongs_to :voter, class_name: 'User', foreign_key: 'voter_id'
  belongs_to :votable, :polymorphic => true, touch: true

  validates_presence_of :votable_id
  validates_presence_of :voter_id

  #Callbacks for storing cache in redis
  after_destroy :update_counters, :delete_cached_voters_ids, :delete_notification
  after_commit :update_counters, :cache_voters_ids, on: :create

  public

  def votable_user
    votable.user
  end

  private

  def rebuild_cache
    #rebuild counters and cached_ids for votable
    UpdateVoteCacheJob.perform_later(votable_id, votable_type)
  end

  def update_counters
    #Increment votes counter
    votable.votes_counter.reset
    votable.votes_counter.incr(votable.votes.size)
  end

  def cache_voters_ids
    #Cache voters ids in redis
    votable.voters_ids << voter_id unless votable.voted?(voter)
  end

  def delete_cached_voters_ids
    #Delete cached voters ids in redis
    votable.voters_ids.delete(voter_id) if votable.voted?(voter)
  end

  #Delete notification before destroying vote
  def delete_notification
    #delete notification if record is destroyed
    DeleteUserNotificationJob.perform_later(self.id, self.class.to_s)
  end

end