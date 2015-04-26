class UpdateUserFeedJob < ActiveJob::Base
  def perform(activity_id)
    @activity = Activity.find(activity_id)
    ActiveRecord::Base.connection_pool.with_connection do
      User.find(@activity.user.followers).each do |follower|
        follower.latest_activities.add(@activity.id, @activity.created_at.to_i)
      end
    end
  end
end
