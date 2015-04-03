class UnlikeNotificationJob < ActiveJob::Base

  def perform(object)
    ActiveRecord::Base.connection_pool.with_connection do
      if Mailboxer::Notification.where(notification_code: "like_#{object.id}_#{object.class.name}").exists?
        Mailboxer::Notification.where(notification_code: "like_#{object.id}_#{object.class.name}").find_each do |notification|
          notification.destroy
        end
      end
    end
  end
end
