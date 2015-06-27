class Follow < ActiveRecord::Base

  include IdentityCache

  belongs_to :follower, polymorphic: true
  belongs_to :followable, polymorphic: true, touch: true

  # Validations
  validates :followable, presence: true
  validates :follower, presence: true

  after_create :increment_counters
  before_destroy :decrement_counters, :delete_notification

  private

  #Redis Counters
  def increment_counters
   #Increment counters
   follower.followings_counter.increment
   followable.followers_counter.increment
   #Add ids to follower and followable cache
   follower.followings_ids << followable_id if followable_type == "User"
   follower.idea_followings_ids << followable_id if followable_type == "Idea"
   follower.school_followings_ids << followable_id if followable_type == "School"
   followable.followers_ids << follower_id
  end

  def decrement_counters
   #Decrement counters
   follower.followings_counter.decrement
   followable.followers_counter.decrement
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
