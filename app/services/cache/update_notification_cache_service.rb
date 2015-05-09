class UpdateNotificationCacheService

  include Rails.application.routes.url_helpers

  def initialize(user, activity)
    @activity = activity #already persist in Postgres
    @actor = user
    @object = activity.trackable
    @target = activity.recipient
  end

  def update
    update_activity(@actor, activity)
  end

  protected

  def activity
    {
      id: @activity.id,
      verb: @activity.verb,
      type: @activity.class.to_s.downcase,
      actor: options_for_actor(@actor),
      event: options_for_object(@object),
      recipient: options_for_target(@target),
      created_at: "#{@activity.created_at.to_formatted_s(:iso8601)}",
      unread: false
    }
  end

  def update_activity(user, activity_item)
    user.latest_notifications.delete(activity_item)
    idea.latest_notifications.add(activity_item, @activity.created_at.to_i)
  end


  def options_for_object(target)
    if @activity.trackable_type == "User"
      trackable_user_name =   target.name
      trackable_user_id =   target.id
    elsif @activity.trackable_type == "Idea"
      trackable_user_name = target.student.name
      trackable_user_id =   target.student.id
    elsif @activity.trackable_type == "Follow"
      trackable_user_name = target.follower.name
      trackable_user_id =   target.follower.id
    elsif @activity.trackable_type == "Vote"
      trackable_user_name = target.voter.name
      trackable_user_id =   target.voter.id
    else
      trackable_user_name = target.user.name
      trackable_user_id =   target.user.id
    end

    if !target.nil?
      {
        id: target.id,
        event_name: @activity.trackable_type.downcase,
        event_user_id: trackable_user_id,
        event_recipient_name: trackable_user_name
      }
    else
      nil
    end
  end

  def options_for_target(target)
    if @activity.recipient_type == "Idea"
      recipient_user_id =  target.student.id
      recipient_user_name = target.student.name
      recipient_name = target.name
    elsif @activity.recipient_type == "User"
      recipient_user_id = @activity.recipient_id
      recipient_user_name =   target.name
      recipient_name = target.name
    else
      recipient_user_id =  target.user.id
      recipient_user_name = target.user.name
      recipient_name = target.user.name
    end

    if !target.nil?
      {
        recipient_user_id: recipient_user_id,
        recipient_user_name: recipient_user_name,
        recipient_name: recipient_name,
        recipient_type: @activity.recipient_type.downcase,
      }
    else
      nil
    end
  end

  def options_for_actor(target)
    avatar = @activity.user.avatar.url(:avatar) if @activity.user.avatar.present?
    if !target.nil?
      {
        id: target.id,
        url: profile_path(target),
        actor_name_badge: @activity.user.user_name_badge,
        actor_avatar: avatar,
        actor_name: target.name
      }
    else
      nil
    end
  end

end