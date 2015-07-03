class Vote < ActiveRecord::Base

  #Model Associations
  belongs_to :voter, class_name: 'User', foreign_key: 'voter_id'
  belongs_to :votable, :polymorphic => true, touch: true

  validates_presence_of :votable_id
  validates_presence_of :voter_id

  #Callbacks for storing cache in redis
  before_destroy :decrement_counter, :delete_notification
  after_commit :increment_counter, on: :create

  public

  def votable_user
    votable.user
  end

  private

  def rebuild_cache
    #rebuild counters and cached_ids for votable
    UpdateVoteCacheJob.perform_later(votable_id, votable_type)
  end

  def increment_counter
    #Increment votes counter
    votable.votes_counter.incr(votable.votes.size)
    votable.voters_ids << voter_id unless votable.voted?(voter)
  end

  #Rollback counters for votable
  def decrement_counter
    #Decrement score for votable and decrement votes counter
    votable.votes_counter.incr(votable.votes.size)
    votable.voters_ids.delete(voter_id) if votable.voted?(voter)
  end

  #Delete notification before destroying vote
  def delete_notification
    #delete notification if record is destroyed
    DeleteUserNotificationJob.perform_later(self.id, self.class.to_s)
  end

end