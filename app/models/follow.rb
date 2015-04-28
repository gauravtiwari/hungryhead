class Follow < ActiveRecord::Base

  belongs_to :follower, polymorphic: true
  belongs_to :followable, polymorphic: true

  # Validations
  validates :followable, presence: true
  validates :follower, presence: true

  after_create :increment_counters
  before_destroy :decrement_counters, :delete_notification
  #before_destroy :remove_activity

  private

  #Redis Counters
  def increment_counters
    follower.followings_counter.increment
    followable.followers_counter.increment
    follower.followings_ids.add(followable_id, created_at.to_i) if followable_type == "User"
    follower.idea_followings_ids.add(followable_id, created_at.to_i) if followable_type == "Idea"
    followable.followers_ids.add(follower_id, created_at.to_i)

    #Send stats via pusher
    publish_stats
  end

  def decrement_counters
    follower.followings_counter.decrement
    followable.followers_counter.decrement
    follower.followings_ids.delete(followable_id) if followable_type == "User"
    follower.idea_followings_ids.delete(followable_id) if followable_type == "Idea"
    followable.followers_ids.delete(follower_id)

    #Send stats via pusher
    publish_stats
  end

  def publish_stats
    #Trigger pusher to update stats
    Pusher.trigger_async("user-stats-#{followable.id}",
     "user_stats_update",
       {data:
         {
           id: followable.id,
           followers_count: followable.followers_counter.value
         }
       }.to_json
    )
  end

  def delete_notification
    DeleteUserNotificationJob.perform_later(self.id, self.class.to_s)
  end

end
