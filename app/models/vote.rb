class Vote < ActiveRecord::Base

  #Model Associations
  belongs_to :voter, :polymorphic => true
  belongs_to :votable, :polymorphic => true, touch: true

  validates_presence_of :votable_id
  validates_presence_of :voter_id

  #Callbacks for storing cache in redis
  after_destroy :delete_notification
  after_create :update_redis_cache

  public

  def votable_user
    votable.user
  end

  private

  def update_redis_cache
    CacheVoteToRedisJob.perform_later(votable_id, votable_type)
  end

  #Delete notification before destroying vote
  def delete_notification
    #delete notification if record is destroyed
    DeleteUserNotificationJob.perform_later(self.id, self.class.to_s)
  end

end
