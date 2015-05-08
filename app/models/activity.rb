class Activity < ActiveRecord::Base
  include Renderable
  include Feedable

  #after_commit :build_notifications, on: :create

  #private

  #def build_notification_feed
   # BuildUserNotificationFeedJob.perform_later(user.id)
  #end


  after_save :update_activity_feed

  private

  def update_activity_feed
    ActivityFeed.add_item(self.user_id, self.id, self.created_at.to_i)
  end

end
