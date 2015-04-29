class DeleteUserNotificationJob < ActiveJob::Base
  def perform(trackable_id, trackable_type)
    ActiveRecord::Base.connection_pool.with_connection do
      Notification.where(trackable_id: trackable_id, trackable_type: trackable_type).find_each do |notification|
        notification.destroy if notification.present?
      end
    end
  end
end
