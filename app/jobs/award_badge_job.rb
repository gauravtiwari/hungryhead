class AwardBadgeJob < ActiveJob::Base
  def perform(user, badge_id, msg, category)
    ActiveRecord::Base.connection_pool.with_connection do
      user.add_badge(badge_id)
      @badge = Merit::Badge.find(badge_id)
      user.add_points(@badge.custom_fields[:points], category: "#{category}")
      Pusher.trigger_async("private-user-#{user.id}", "new_badge", {data: @badge}.to_json)
    end
  end
end
