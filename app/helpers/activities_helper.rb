module ActivitiesHelper
  def cached_key_for_activity(activity)
    "activities/activity-#{activity.trackable_type}-#{activity.trackable_id}-user-#{current_user.id}"
  end
end