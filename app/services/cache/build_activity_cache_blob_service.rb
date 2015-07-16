class BuildActivityCacheBlobService

  include Rails.application.routes.url_helpers

  def initialize(activity)
    @activity = activity
    @actor = activity.owner
    @object = activity.trackable
    @target = activity.recipient
  end

  def call
    generate_activity_blob
  end

  private

  def find_activity_id
    if @activity.class.to_s == "Notification"
      return @activity.parent_id
    else
      return @activity.uuid
    end
  end

  def generate_activity_blob
    {
      id: @activity.id,
      verb: @activity.verb,
      activity_id: find_activity_id,
      type: @activity.class.to_s.downcase,
      actor: options_for_actor(@actor),
      event: options_for_object(@object),
      recipient: options_for_target(@target),
      created_at: "#{@activity.created_at.to_formatted_s(:iso8601)}"
    }
  end

  def options_for_object(target)
    if @activity.trackable_type == "User"
      trackable_user_name =   target.name
      trackable_user_id =   target.id
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
    {
      id: target.id,
      event_name: @activity.trackable_type.downcase,
      event_user_id: trackable_user_id,
      event_recipient_name: trackable_user_name
    }
  end

  def options_for_target(target)
    if @activity.recipient_type == "Idea"
      recipient_user_id =  target.user.id
      recipient_url = idea_path(target)
      recipient_name = target.name
    elsif @activity.recipient_type == "User"
      recipient_user_id = @activity.recipient_id
      recipient_url = profile_path(target)
      recipient_name = target.name
    elsif @activity.recipient_type == "School"
      recipient_user_id = target.user.id
      recipient_url = profile_path(target)
      recipient_name = target.name
    elsif @activity.recipient_type == "Share"
      recipient_user_id = target.owner.id
      recipient_url = profile_path(target.owner)
      recipient_name = target.owner.name
    elsif @activity.recipient_type == "Event"
      recipient_user_id = target.owner.id
      recipient_url = profile_path(target.owner)
      recipient_name = target.owner.name
    else
      recipient_user_id =  target.user.id
      recipient_url = profile_activities_activity_path(target.user, find_activity_id)
      recipient_name = target.user.name
    end

    {
      recipient_user_id: recipient_user_id,
      recipient_url: recipient_url,
      recipient_name: recipient_name,
      recipient_type: @activity.recipient_type.downcase,
    }

  end

  def options_for_actor(target)
    avatar = @activity.owner.get_avatar if @activity.owner.avatar_present?
    actor_name_badge = @activity.owner.name_badge

    {
      id: target.id,
      url: profile_path(target),
      actor_name_badge: actor_name_badge,
      actor_avatar: avatar,
      actor_name: target.name
    }

  end


end