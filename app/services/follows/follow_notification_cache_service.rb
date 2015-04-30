class FollowNotificationCacheService

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
    avatar = @activity.user.avatar.url(:avatar) if @activity.user.avatar.present?
    recipient_user_id = @activity.recipient_type == "Idea" && @activity.recipient_type != "School" ? @activity.recipient.student_id : @activity.recipient_id
    info = @activity.recipient_type == "Idea" && @activity.recipient_type != "School" ? @activity.recipient.high_concept_pitch : @activity.recipient.mini_bio
    {
      actor: @activity.user.name,
      actor_id: @activity.user.id,
      recipient: @activity.recipient.name,
      recipient_user_id: recipient_user_id,
      recipient_type: @activity.recipient_type.to_s.downcase,
      info: info,
      id: @activity.id,
      actor_name_badge: @activity.notification.user.user_name_badge,
      created_at: "#{@activity.created_at.to_formatted_s(:iso8601)}",
      actor_avatar: avatar,
      url: Rails.application.routes.url_helpers.profile_path(@activity.user),
      verb: @activity.verb
    }
  end

end