class Follow < ActiveRecord::Base

  belongs_to :follower, polymorphic: true
  belongs_to :followable, polymorphic: true

  counter_culture :follower
  counter_culture :followable

  # Validations
  validates :followable, presence: true
  validates :follower, presence: true

  after_commit :cache_ids, on: :create
  before_destroy :remove_cache_ids, :delete_notification

  private

  #Redis Counters
  def cache_ids
    follower.followings_ids.push(followable_id) if followable_type == "User"
    follower.idea_followings_ids.push(followable_id) if followable_type == "Idea"
    followable.followers_ids.push(follower_id)
    followable.score + 1
    follower.score + 1

    save_cache
  end

  def remove_cache_ids
    follower.followings_ids.delete(followable_id.to_s)
    follower.idea_followings_ids.delete(followable_id.to_s) if followable_type == "Idea"
    followable.followers_ids.delete(follower_id.to_s)
    followable.score - 1
    follower.score - 1
  end

  def save_cache
    followable.save
    follower.save

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
           followers_count: followable.followers_count
         }
       }.to_json
    )
  end

  def delete_notification
    DeleteUserNotificationJob.perform_later(self.id, self.class.to_s)
  end

end
