class ActivityPresenter < SimpleDelegator
  attr_reader :activity

  def initialize(activity, view)
    super(view)
    @activity = activity
  end

  def as_json(*)
    mentioner = @activity.trackable.mentioner.class.to_s.downcase if @activity.trackable_type == "Mention"
    recipient = @activity.recipient_type == "Comment" ? @activity.recipient.user.name : @activity.recipient.name
    {
      actor: @activity.user.name,
      recipient: recipient,
      recipient_type: mentioner || nil,
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
      "#{activity.type.downcase.pluralize}/#{activity.key.split('.').first}/#{activity.key.split('.').second}",
      "#{activity.type.downcase.pluralize}/#{activity.key.split('.').first}",
      "#{activity.type.downcase.pluralize}/activity"
    ]
  end
end