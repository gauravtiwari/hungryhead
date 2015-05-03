class DeleteUserNotificationJob < ActiveJob::Base
  def perform(trackable_id, trackable_type)
    ActiveRecord::Base.connection_pool.with_connection do
      Notification.where(trackable_id: trackable_id, trackable_type: trackable_type).find_each do |notification|
        notification.user.latest_notifications.remrangebyscore(notification.created_at.to_i, notification.created_at.to_i)

        #Find followers for this notification and remove notification from it's feed
        find_followers(notification).each do |f|
          f.latest_notifications.remrangebyscore(notification.created_at.to_i, notification.created_at.to_i)
        end

        #if recipient is idea, remove from the idea feed
        if notification.recipient_type == "Idea"
          notification.recipient.latest_notifications.remrangebyscore(notification.created_at.to_i, notification.created_at.to_i)
        end

        #finally destroy the notification from DB
        notification.destroy if notification.present?
      end
    end
  end

  #fetch all followers followed by actor
  def find_followers(notification)
    followers_ids = notification.user.followers_ids.values
    followers = followers_ids.include?(recipient_id(notification).to_s) ? followers_ids : followers_ids.push(recipient_id(notification).to_s)
    User.find(followers)
  end

  #get recipient idea // user
  def recipient_id(notification)
    if notification.recipient_type == "User"
      notification.recipient.id
    elsif notification.recipient_type == "Idea"
      notification.recipient.student.id
    else
      notification.recipient.user.id
    end
  end

end