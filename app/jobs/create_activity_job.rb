class CreateActivityJob < ActiveJob::Base

  def perform(trackable_id, trackable_type)
    ActiveRecord::Base.connection_pool.with_connection do
      if trackable_type.constantize.find(trackable_id).present?
        @trackable = trackable_type.constantize.find(trackable_id)
      else
        return false
      end
      if find_trackable(@trackable)
        return false
      else
        "Create#{trackable_type}NotificationService".constantize.new(@trackable).create
      end
    end
  end

  def find_trackable(trackable)
    @activity = Activity.where(trackable: trackable)
    @notification = Notification.where(trackable: trackable)
    @activity.exists? && @activity.first.published? || @notification.exists? && @notification.first.published?
  end

end