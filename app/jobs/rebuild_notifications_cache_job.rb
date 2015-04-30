class RebuildNotificationsCacheJob < ActiveJob::Base

  def perform(user_id)
    ActiveRecord::Base.connection_pool.with_connection do
      @user = User.find(user_id)
      @user.latest_notifications.clear
      @user.activities.find_each do |activity|
        "#{activity.trackable_type}NotificationCacheService".constantize.new(activity).cache unless activity.trackable_type == "User"
      end
      @user.notifications.find_each do |notification|
        "#{notification.trackable_type}NotificationCacheService".constantize.new(notification).cache unless notification.trackable_type == "User"
      end
    end
  end

end
