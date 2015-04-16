class Follow < ActiveRecord::Base
  acts_as_follow

  after_create :add_following
  after_create :add_follower
  before_destroy :delete_following
  before_destroy :delete_follower


  private 

  def add_following
  	follower.followings_counter.increment
  	follower.followings_ids << followable_id
  end

  def add_follower
  	followable.followers_counter.increment
  	followable.followers_ids << follower_id
  end

  def delete_following
  	follower.followings_counter.decrement
  	follower.followings_ids.delete(followable_id)
  end

  def delete_follower
  	followable.followers_counter.decrement
  	followable.followers_ids.delete(follower_id)
  end

end
