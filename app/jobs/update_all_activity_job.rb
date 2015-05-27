class UpdateAllActivityJob < ActiveJob::Base
  def perform(user)
    ActiveRecord::Base.connection_pool.with_connection do
      Notification.where(id: user.friends_notifications.members.map{|m| m[:id]}).where("parameters ->> 'unread' = 'true'").find_each do |notification|
        notification.unread = false
        notification.save
        UpdateNotificationCacheService.new(notification).update
      end
      Notification.where(id: user.friends_notifications.members.map{|m| m[:id]}).where("parameters ->> 'unread' = 'true'").find_each do |activity|
        activity.unread = false
        activity.save
        UpdateNotificationCacheService.new(activity).update
      end
    end
  end
end