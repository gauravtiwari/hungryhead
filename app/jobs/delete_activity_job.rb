class DeleteActivityJob < ActiveJob::Base
  def perform(trackable_id, trackable_type)
    ActiveRecord::Base.connection_pool.with_connection do
      Activity.where(trackable_id: trackable_id, trackable_type: trackable_type).find_each do |activity|

        #Remove activity from follower and recipient
        activity.user.get_followers.each do |f|
          f.ticker.remrangebyscore(activity.created_at.to_i + activity.id, activity.created_at.to_i + activity.id)
        end

        #finally remove from recipient ticker and notification
        activity.recipient_user.ticker.remrangebyscore(activity.created_at.to_i + activity.id, activity.created_at.to_i + activity.id)
        activity.recipient_user.friends_notifications.remrangebyscore(activity.created_at.to_i + activity.id, activity.created_at.to_i + activity.id)

        #finally destroy the activity
        activity.destroy if activity.present?

      end
    end
  end

end