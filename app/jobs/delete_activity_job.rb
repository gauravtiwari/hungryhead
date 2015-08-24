class DeleteActivityJob < ActiveJob::Base
  def perform(trackable_id, trackable_type)
    ActiveRecord::Base.connection_pool.with_connection do
      Activity.where(trackable_id: trackable_id, trackable_type: trackable_type).each do |activity|
        #Delete cached activities
        DeleteNotificationCacheService.new(activity).delete
        #finally destroy the activity
        activity.destroy if activity.present?
      end
    end
  end
end