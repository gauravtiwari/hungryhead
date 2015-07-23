class DeleteUserNotificationJob < ActiveJob::Base
  def perform(trackable_id, trackable_type)

    ActiveRecord::Base.connection_pool.with_connection do
      Notification.where(trackable_id: trackable_id, trackable_type: trackable_type).find_each do |notification|

        #Delete from user ticker
        notification.user.ticker.remrangebyscore(notification.created_at.to_i + notification.id, notification.created_at.to_i + notification.id)

        #delete from user latest activities profile
        notification.user.latest_activities.remrangebyscore(notification.created_at.to_i + notification.id, notification.created_at.to_i + notification.id)

        #Find followers for this notification and remove notification from it's feed
        find_followers(notification).each do |f|
          f.ticker.remrangebyscore(notification.created_at.to_i + notification.id, notification.created_at.to_i + notification.id)
        end

        #finally remove from recipient ticker and notification
        recipient_user(notification).ticker.remrangebyscore(notification.created_at.to_i + notification.id, notification.created_at.to_i + notification.id)
        recipient_user(notification).friends_notifications.remrangebyscore(notification.created_at.to_i + notification.id, notification.created_at.to_i + notification.id)

        #finally destroy the notification from DB
        notification.destroy if notification.present?

      end
    end
  end

  #find all followers followed by actor
  def find_followers(notification)
    followers_ids = notification.user.followers_ids.members
    @followers = User.find(followers_ids) unless followers_ids.empty?
    @followers || []
  end

  #get recipient idea // user
  def recipient_user(notification)
    if notification.recipient_type == "User"
      notification.recipient
    elsif notification.recipient_type == "Idea"
      notification.recipient.user
    else
      notification.recipient.user
    end
  end

end