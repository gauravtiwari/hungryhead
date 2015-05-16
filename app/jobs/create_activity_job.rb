class CreateActivityJob < ActiveJob::Base
  def perform(trackable_id, trackable_type)
    ActiveRecord::Base.connection_pool.with_connection do
      @trackable = trackable_type.constantize.find(trackable_id)
      if find_trackable(@trackable)
        false
      else
        "Create#{trackable_type}NotificationService".constantize.new(@trackable).create
      end
    end
  end

  def find_trackable(trackable)
    @activity = Activity.where(trackable_id: trackable.id, trackable_type: trackable.class.to_s)
    @notification = Notification.where(trackable_id: trackable.id, trackable_type: trackable.class.to_s)
    @activity.exists? && @activity.first.published? || @notification.exists? && @notification.first.published?
  end
end