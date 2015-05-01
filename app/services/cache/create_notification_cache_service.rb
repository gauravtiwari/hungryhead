class CreateNotificationCacheService

  include Rails.application.routes.url_helpers

  def initialize(activity)
    @activity = activity #already persist in Postgres
    @actor = activity.user
    @object = activity.trackable
    @target = activity.recipient
  end

  def create
    add_activity(@actor, activity)
    SendNotificationService.new(@activity).user_notification
    SendNotificationService.new(@activity).idea_notification if @activity.trackable_type == "Idea"
  end

  protected

  def activity
    {
      id: @activity.id,
      verb: @activity.verb,
      actor: options_for_actor(@actor),
      object: options_for_object(@object),
      target: options_for_target(@target),
      created_at: "#{@activity.created_at.to_formatted_s(:iso8601)}",
    }
  end

  def followers
    User.find(@actor.followers_ids.members)
  end

  def add_activity(user, activity_item)
    add_activity_to_user(user, activity_item)
    add_activity_to_followers(activity_item) if followers.any?
  end

  def add_activity_to_user(user, activity_item)
    user.latest_notifications.add(activity_item, @activity.created_at.to_i)
  end

  def add_activity_to_followers(activity_item)
    followers.each { |follower| add_activity_to_user(follower, activity_item) }
  end

  def options_for_object(target)
    if !target.nil?
      {
        id: target.id,
        class_name: target.class.to_s,
        display_name: target.to_s
      }
    else
      nil
    end
  end

  def options_for_target(target)
    recipient_name = @activity.recipient_type == "Comment" || @activity.recipient_type == "Share" || @activity.recipient_type == "Investment" || @activity.recipient_type == "Feedback" || @activity.recipient_type == "Note"? @activity.recipient.user.name : @activity.recipient.name
    if @activity.recipient_type == "Idea"
      recipient_user_id =  @activity.recipient.student.id
    elsif @activity.recipient_type == "User"
      recipient_user_id = @activity.recipient_id
    else
      recipient_user_id =  @activity.recipient.user.id
    end

    if !target.nil?
      {
        recipient_user_id: recipient_user_id,
        recipient: recipient_name,
        recipient_type: @activity.recipient_type.to_s.downcase,
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
        name_badge: @activity.user.user_name_badge,
        avatar: avatar,
        class_name: target.class.to_s,
        display_name: target.to_s
      }
    else
      nil
    end
  end

end

