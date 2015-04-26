class ActivityPresenter < SimpleDelegator
  attr_reader :activity

  def initialize(activity, view)
    super(view)
    @activity = activity
  end

  def as_json(*)
    {
      actor: @activity.user.name,
      recipient: @activity.recipient.name,
      recipient_type: @activity.trackable.class.to_s.downcase,
      id: @activity.id,
      created_at: "#{@activity.created_at}",
      url: Rails.application.routes.url_helpers.profile_path(@activity.user),
      verb: @activity.verb
    }
  end

  def render_activity
    render_partial
  end

  def render_partial
    locals = {activity: activity, presenter: self}
    locals[activity.trackable_type.underscore.to_sym] = activity.trackable
    render partial_path, locals
  end

  def partial_path
    partial_paths.detect do |path|
      lookup_context.template_exists? path, nil, true
    end || raise("No partial found for activity in #{partial_paths}")
  end

  def partial_paths
    [
      "#{activity.type.downcase.pluralize}/#{activity.trackable_type.underscore}/#{activity.key}",
      "#{activity.type.downcase.pluralize}/#{activity.trackable_type.underscore}",
      "#{activity.type.downcase.pluralize}/activity"
    ]
  end
end