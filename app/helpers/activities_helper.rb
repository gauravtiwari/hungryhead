module ActivitiesHelper
  def render_activity activity
   render partial: partial_path(activity), locals: {activity: activity}
  end

  alias_method :render_activities, :render_activity

  def partial_path(activity)
    partial_paths(activity).detect do |path|
      lookup_context.template_exists? path, nil, true
    end || raise("No partial found for activity in #{partial_paths(activity)}")
  end

  def partial_paths(activity)
    [
      "activities/#{activity.key.to_s.gsub('.', '/')}",
      "activities/#{activity.trackable_type.underscore}",
      "activities/activity"
    ]
  end
end
