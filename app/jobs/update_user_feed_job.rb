class UpdateUserFeedJob < ActiveJob::Base
  def perform(activity)
    @activity = activity
    ActiveRecord::Base.connection_pool.with_connection do
      User.find(@activity.owner.followers_ids.members).each do |follower|
        follower.latest_activities.add(@activity.id, @activity.created_at.to_i)
      end
    end
  end
end
