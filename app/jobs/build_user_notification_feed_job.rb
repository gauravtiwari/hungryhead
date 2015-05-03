class BuildUserNotificationFeedJob < ActiveJob::Base

  def perform(user_id)
    ActiveRecord::Base.connection_pool.with_connection do
      @user = User.find(user_id)
      @user.notification_feed.clear
      notification_sets  = []
      User.find(@user.followers_ids.values).each do |follower|
       notification_sets =  follower.latest_notifications
      end
      notification_sets.push(@user.latest_notifications)
      @user.notification_feed = notification_sets.map{|feed| feed.union(feed) }
    end
  end

end
