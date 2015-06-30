class Follow < ActiveRecord::Base

  belongs_to :follower, polymorphic: true
  belongs_to :followable, polymorphic: true, touch: true

  # Validations
  validates :followable, presence: true
  validates :follower, presence: true

  after_commit :delete_notification, :update_redis_cache, on: [:create, :destroy]
  after_destroy :delete_notification

  private

  #Update Redis Counters/Followers cache
  def update_redis_cache
    CacheFollowToRedisJob.perform_later(follower_id, followable_id, followable_type)
  end

  #Delete notification activity for follow
  def delete_notification
    DeleteUserNotificationJob.perform_later(self.id, self.class.to_s) unless followable_type == "School"
  end

end
