class DeleteUserNotificationJob < ActiveJob::Base
  def perform(trackable_id, trackable_type)
    ActiveRecord::Base.connection_pool.with_connection do
      Notification.where(trackable_id: trackable_id, trackable_type: trackable_type).find_each do |notification|
        notification.user.latest_notifications.delete(notification_json(notification))
        if notification.recipient_type == "Idea"
          recipient.latest_notifications.add(notification_json(notification))
        end
        notification.destroy if notification.present?
      end
    end
  end

  def notification_json(notification)
    mentioner = notification.trackable.mentioner.class.to_s.downcase if notification.trackable_type == "Mention"
    recipient_name = notification.recipient_type == "Comment" ? notification.recipient.user.name : notification.recipient.name
    {
      actor: notification.user.name,
      recipient: recipient_name,
      recipient_type: mentioner || nil.to_s,
      id: notification.id,
      created_at: "#{notification.created_at.to_i}",
      url: Rails.application.routes.url_helpers.profile_path(notification.user),
      verb: notification.verb
    }
  end

end
