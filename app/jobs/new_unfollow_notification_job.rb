class NewUnfollowNotificationJob < ActiveJob::Base

  def perform(user, recipient)
    ActiveRecord::Base.connection_pool.with_connection do
      if Mailboxer::Notification.where(notification_code: "follow_#{recipient.class.name}_#{recipient.id}").exists?
        Mailboxer::Notification.where(notification_code: "follow_#{recipient.class.name}_#{recipient.id}").find_each do |notification|
          notification.destroy
        end
      end
    end
  end
end
