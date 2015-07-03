class Follow < ActiveRecord::Base

  belongs_to :follower, class_name: 'User', foreign_key: 'follower_id'
  belongs_to :followable, polymorphic: true, touch: true

  # Validations
  validates :followable, presence: true
  validates :follower, presence: true

  after_commit :increment_counters, on: :create
  before_destroy :decrement_counters, :delete_notification

  private

  #Redis Counters
  def increment_counters
   #Increment counters
   follower.followings_counter.incr(follower.followings.size)
   followable.followers_counter.incr(followable.followers.size)
   #Add ids to follower and followable cache
   follower.followings_ids << followable_id if followable_type == "User"
   follower.idea_followings_ids << followable_id if followable_type == "Idea"
   follower.school_followings_ids << followable_id if followable_type == "School"
   followable.followers_ids << follower_id unless followable.followers_ids.include?(follower_id.to_s)
  end

  def decrement_counters
   #Decrement counters
   follower.followings_counter.incr(follower.followings.size)
   followable.followers_counter.incr(followable.followers.size)
   #Delete cached ids
   follower.followings_ids.delete(followable_id) if followable_type == "User"
   follower.idea_followings_ids.delete(followable_id) if followable_type == "Idea"
   follower.school_followings_ids.delete(followable_id) if followable_type == "School"
   followable.followers_ids.delete(follower_id)
  end

  def delete_notification
    DeleteUserNotificationJob.perform_later(self.id, self.class.to_s) unless followable_type == "School"
  end

end