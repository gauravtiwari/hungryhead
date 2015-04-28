class DeleteUserFeedJob < ActiveJob::Base
  def perform(trackable_id, trackable_type)
    ActiveRecord::Base.connection_pool.with_connection do
      Activity.where(trackable_id: trackable_id, trackable_type: trackable_type).find_each do |activity|
        activity.user.latest_notifications.remrangebyscore(activity.created_at.to_i, activity.created_at.to_i)
        if activity.recipient_type == "Idea"
          recipient.latest_notifications.remrangebyscore(activity.created_at.to_i, activity.created_at.to_i)
        end
        activity.destroy if activity.present?
      end
    end
  end
end
