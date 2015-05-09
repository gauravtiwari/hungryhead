class Follow < ActiveRecord::Base

  belongs_to :follower, polymorphic: true
  belongs_to :followable, polymorphic: true

  # Validations
  validates :followable, presence: true
  validates :follower, presence: true

  after_commit :increment_counters, on: :create
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

    #Increment popularity score
    Idea.popular.increment(followable.idea_json) if followable_type == "Idea"
    User.popular.increment(followable.user_json) if followable_type == "User"

  end

  def decrement_counters
    #Decrement counters
    follower.followings_counter.decrement
    followable.followers_counter.decrement
    #Delete cached ids for follower and followable
    follower.followings_ids.delete(followable_id) if followable_type == "User"
    follower.idea_followings_ids.delete(followable_id) if followable_type == "Idea"
    follower.school_followings_ids.delete(followable_id) if followable_type == "School"
    followable.followers_ids.delete(follower_id)
    #Decrement popularity score
    Idea.popular.decrement(followable.idea_json) if followable_type == "Idea"
    User.popular.decrement(followable.user_json) if followable_type == "User"

  end

  def delete_notification
    DeleteUserNotificationJob.perform_later(self.id, self.class.to_s) unless followable_type == "School"
  end

end
