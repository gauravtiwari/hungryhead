class RemoveBadgeJob < ActiveJob::Base
  def perform(user_id, badge_id, category)
    ActiveRecord::Base.connection_pool.with_connection do
      @user = User.find(user_id)
      @user.rm_badge(badge_id)
      @badge = Merit::Badge.find(badge_id)
      @user.subtract_points(@badge.custom_fields[:points], category: "#{category}")
    end
  end
end
