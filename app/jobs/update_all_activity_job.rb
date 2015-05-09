class UpdateAllActivityJob < ActiveJob::Base
  def perform(user)
    ActiveRecord::Base.connection_pool.with_connection do
      user.notifications.where("parameters ->> 'read' = 'false'").find_each do |notification|
        notification.read = true
        notification.save
        UpdateNotificationCacheService.new(user, notification).update
      end
    end
  end
end