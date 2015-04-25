class Follow < ActiveRecord::Base

  acts_as_follow
  include PublicActivity::Model

  tracked only: [:create],
  owner: ->(controller, model) { controller && controller.current_user },
  recipient: ->(controller, model) { model && model.followable },
  params: {verb: "followed", action:  ->(controller, model) { model && model.followable.name }}

  after_create :increment_counters
  before_destroy :decrement_counters
  before_destroy :remove_activity

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

  def remove_activity
   PublicActivity::Activity.where(trackable_id: self.id, trackable_type: self.class.to_s).find_each do |activity|
    DeleteUserFeedJob.perform_later(activity)
   end
  end

end
