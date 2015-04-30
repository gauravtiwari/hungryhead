class RebuildNotificationsCacheJob < ActiveJob::Base

  def perform
    ActiveRecord::Base.connection_pool.with_connection do
      Activity.find_each do |activity|
        "#{activity_trackable_type}NotificationCacheService".constantize.new(activity).cache
      end
      Notification.find_each do |notification|
        "#{activity_trackable_type}NotificationCacheService".constantize.new(activity).cache
      end
    end
  end

end
