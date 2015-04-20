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

  def increment_counters
  	follower.followings_counter.increment
    followable.followers_counter.increment
    follower.followings_ids << followable_id if followable.class.to_s == "User"
    follower.idea_followings_ids << followable_id if followable.class.to_s == "Idea"
    followable.followers_ids << follower_id
  end

  def decrement_counters
  	follower.followings_counter.decrement
    followable.followers_counter.decrement
    follower.followings_ids.delete(followable_id) if followable.class.to_s == "User"
    follower.idea_followings_ids.delete(followable_id) if followable.class.to_s == "Idea"
    followable.followers_ids.delete(follower_id)
  end

  def remove_activity
   PublicActivity::Activity.where(trackable_id: self.id, trackable_type: self.class.to_s).find_each do |activity|
    activity.destroy if activity.present?
    true
   end
  end

end
