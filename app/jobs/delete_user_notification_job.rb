class DeleteUserNotificationJob < ActiveJob::Base
  def perform(trackable_id, trackable_type)
    ActiveRecord::Base.connection_pool.with_connection do
      Notification.where(trackable_id: trackable_id, trackable_type: trackable_type).find_each do |notification|
        notification.user.latest_notifications.remrangebyscore(notification.created_at.to_i, notification.created_at.to_i)
        if notification.recipient_type == "Idea"
          notification.recipient.latest_notifications.remrangebyscore(notification.created_at.to_i, notification.created_at.to_i)
        end
        notification.destroy if notification.present?
      end
    end
  end
end
