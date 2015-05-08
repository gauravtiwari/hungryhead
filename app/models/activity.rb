class Activity < ActiveRecord::Base
  include Renderable
  include Feedable

  #after_commit :build_notifications, on: :create

  #private

  #def build_notification_feed
   # BuildUserNotificationFeedJob.perform_later(user.id)
  #end

end
