class DeleteActivityJob < ActiveJob::Base
  def perform(trackable_id, trackable_type)
    ActiveRecord::Base.connection_pool.with_connection do
      @trackable = trackable_type.constantize.find(trackable_id)
      Activity.where(trackable: @trackable).find_each do |activity|
        #Delete cached activities
        DeleteNotificationCacheService.new(activity).delete
        #finally destroy the activity
        activity.destroy if activity.present?
      end
    end
  end
end