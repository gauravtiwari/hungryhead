class Follow < ActiveRecord::Base

  belongs_to :follower, polymorphic: true
  belongs_to :followable, polymorphic: true

  # Validations
  validates :followable, presence: true
  validates :follower, presence: true

  after_create :increment_counters
  before_destroy :decrement_counters
  #before_destroy :remove_activity

  private

  #Redis Counters
  def increment_counters
  	follower.followings_counter.increment
    followable.followers_counter.increment
    follower.followings_ids.add(followable_id, created_at.to_i) if followable_type == "User"
    follower.idea_followings_ids.add(followable_id, created_at.to_i) if followable_type == "Idea"
    followable.followers_ids.add(follower_id, created_at.to_i)
  end

  def decrement_counters
  	follower.followings_counter.decrement
    followable.followers_counter.decrement
    follower.followings_ids.delete(followable_id) if followable_type == "User"
    follower.idea_followings_ids.delete(followable_id) if followable_type == "Idea"
    followable.followers_ids.delete(follower_id)
  end

end
