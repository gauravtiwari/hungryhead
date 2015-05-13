class DeleteUserNotificationJob < ActiveJob::Base
  def perform(trackable_id, trackable_type)
    ActiveRecord::Base.connection_pool.with_connection do
      Notification.where(trackable_id: trackable_id, trackable_type: trackable_type).find_each do |notification|
        notification.user.ticker.remrangebyscore(notification.created_at.to_i + notification.id, notification.created_at.to_i + notification.id)

        #Find followers for this notification and remove notification from it's feed
        find_followers(notification).each do |f|
          f.ticker.remrangebyscore(notification.created_at.to_i + notification.id, notification.created_at.to_i + notification.id)
        end

        #if recipient is idea, remove from the idea feed
        if notification.recipient_type == "Idea"
          notification.recipient.ticker.remrangebyscore(notification.created_at.to_i + notification.id, notification.created_at.to_i + notification.id)
        end

        recipient_user.ticker.remrangebyscore(notification.created_at.to_i + notification.id, notification.created_at.to_i + notification.id)
        recipient_user.friends_notifications.remrangebyscore(notification.created_at.to_i + notification.id, notification.created_at.to_i + notification.id)

        #finally destroy the notification from DB
        notification.destroy if notification.present?
      end
    end
  end

  #fetch all followers followed by actor
  def find_followers(notification)
    User.find(followers_ids)
  end

  #get recipient idea // user
  def recipient_user(notification)
    if notification.recipient_type == "User"
      notification.recipient
    elsif notification.recipient_type == "Idea"
      notification.recipient.student
    else
      notification.recipient.user
    end
  end

end