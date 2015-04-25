class DeleteUserFeedJob < ActiveJob::Base
  def perform(activity)
    @activity = activity
    ActiveRecord::Base.connection_pool.with_connection do
      User.find(@activity.user.followers_ids.members).each do |follower|
        follower.latest_activities.delete(@activity.id)
      end
      if @activity.recipient_type == "Idea"
        @activity.recipient.latest_activities.delete(@activity.id)
      end
      @activity.destroy if @activity.present?
    end
  end
end
