class RebuildNotificationsCacheJob < ActiveJob::Base

  def perform(user_id)
    ActiveRecord::Base.connection_pool.with_connection do
      @user = User.find(user_id)
      @user.activities.find_each do |activity|
        UpdateNotificationCacheService.new(activity).update
      end
      @user.notifications.find_each do |notification|
        UpdateNotificationCacheService.new(notification).update
      end
    end
  end

end
