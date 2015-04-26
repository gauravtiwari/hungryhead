class ActivityNotificationJob < ActiveJob::Base
  def perform(activity_id)
    @activity = Activity.find(activity_id)
    ActiveRecord::Base.connection_pool.with_connection do
      @activity.recipient.commenters.each do |user|
        Pusher.trigger("private-user-#{user}",
          "new_feed_item",
          { data: @activity.user.latest_activities.last}
        )
      end
    end
  end
end
