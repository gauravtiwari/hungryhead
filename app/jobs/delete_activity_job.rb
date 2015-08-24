class DeleteActivityJob < ActiveJob::Base
  def perform(trackable_id, trackable_type)
    ActiveRecord::Base.connection_pool.with_connection do
      @trackable = trackable_type.constantize.find(trackable_id)
      activities = Arel::Table.new(:activities)
      activities.where(activities[:trackable_id].eq(trackable_id).and(activities[:trackable_type].eq(trackable_type)).or(activities[:recipient_id].eq(trackable_id).and(activities[:recipient_type].eq(trackable_type))))
      activities.find_each do |activity|
        #Delete cached activities
        DeleteNotificationCacheService.new(activity).delete
        #finally destroy the activity
        activity.destroy if activity.present?
      end
    end
  end
end