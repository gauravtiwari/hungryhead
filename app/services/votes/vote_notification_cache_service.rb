class VoteNotificationCacheService

  def initialize(activity)
    @activity = activity
  end

  def cache
    @activity.user.latest_notifications.add(activity_json, @activity.created_at.to_i)
    if @activity.recipient_type == "Idea"
      @activity.recipient.latest_notifications.add(activity_json, @activity.created_at.to_i)
    end
  end

  def activity_json
    recipient_name = @activity.recipient_type == "Comment" || @activity.recipient_type == "Share" || @activity.recipient_type == "Investment" || @activity.recipient_type == "Feedback" || @activity.recipient_type == "Note"? @activity.recipient.user.name : @activity.recipient.name
    recipient_user_id = @activity.recipient_type == "Idea" ? @activity.recipient.student.id : @activity.recipient.user.id
    avatar = @activity.user.avatar.url(:avatar) if @activity.user.avatar.present?
    {
      actor: @activity.user.name,
      actor_id: @activity.user.id,
      recipient_user_id: recipient_user_id,
      recipient: recipient_name,
      recipient_type: @activity.recipient_type.to_s.downcase,
      id: @activity.id,
      actor_name_badge: @activity.user.user_name_badge,
      created_at: "#{@activity.created_at.to_formatted_s(:iso8601)}",
      actor_avatar: avatar,
      url: Rails.application.routes.url_helpers.profile_path(@activity.user),
      verb: @activity.verb
    }
  end

end