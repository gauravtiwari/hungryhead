class CacheFollowToRedisJob < ActiveJob::Base

  def perform(follower_id, followable_id, followable_type)
    ActiveRecord::Base.connection_pool.with_connection do

      follower = User.fetch(follower_id)
      followable = followable_type.constantize.fetch(followable_id)

      #Increment counters
      follower.followings_counter.incr(follower.fetch_followings.length)
      followable.followers_counter.incr(followable.fetch_followings.length)

      #Add ids to follower and followable cache
      if followable_type == "User"
        follower.followings_ids.clear
        follower.followings_ids << follower.fetch_followings.pluck(:id)
      elsif followable_type == "Idea"
        follower.idea_followings_ids.clear
        follower.idea_followings_ids << follower.fetch_followings.pluck(:id)
      elsif followable_type == "School"
        follower.school_followings_ids << follower.fetch_followings.pluck(:id)
      end

      #Cache followers for followable
      followable.followers_ids << followable.fetch_followers.pluck(:id)
    end

  end
end

