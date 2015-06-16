class UpdateNotificationCacheService

  include Rails.application.routes.url_helpers

  def initialize(activity)
    @activity = activity #already persist in Postgres
    @actor = activity.user
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
      activity_id: find_activity_id,
      type: @activity.class.to_s.downcase,
      actor: options_for_actor(@actor),
      event: options_for_object(@object),
      unread: false,
      recipient: options_for_target(@target),
      created_at: "#{@activity.created_at.to_formatted_s(:iso8601)}"
    }
  end

  def find_activity_id
    if @activity.class.to_s == "Notification"
      return @activity.parent_id
    else
      return @activity.uuid
    end
  end

  #Get recipient user
  def recipient_user
    if @activity.recipient_type == "User"
      @activity.recipient
    else
      @activity.recipient.user
    end
  end

  #Get user followers
  def followers
    followers_ids = @actor.followers_ids.members - [recipient_user.id]
    User.find(followers_ids)
  end

  #Update activity for all tickers
  def update_activity(user, activity_item)
    #add activity to user personal profile
    add_activity_to_user_profile(user, activity_item)
    #push notification into friends notifications
    add_notification_for_recipient(recipient_user, activity_item) unless @activity.user == recipient_user
    #add notification to followers ticker
    add_activity_to_followers(activity_item) if followers.any?
  end

  #Add notification to recipients
  def add_notification_for_recipient(recipient_user, activity_item)
    #delete from notifications
    recipient_user.friends_notifications.remrangebyscore(score_key, score_key)
    recipient_user.friends_notifications.add(activity_item, score_key)
    #delete from recipient ticker
    recipient_user.ticker.remrangebyscore(score_key, score_key)
    recipient_user.ticker.add(activity_item, score_key)
  end

  def add_activity_to_friends_ticker(user, activity_item)
    user.ticker.remrangebyscore(score_key, score_key)
    user.ticker.add(activity_item, score_key)
  end

  #This is for user profile page to show latest personal activities
  def add_activity_to_user_profile(user, activity_item)
    user.latest_activities.remrangebyscore(score_key, score_key)
    user.latest_activities.add(activity_item, score_key)
  end

  #readd notifications to followers tickers
  def add_activity_to_followers(activity_item)
    followers.each do |follower|
      add_activity_to_friends_ticker(follower, activity_item)
    end
  end

  #calculate score key
  def score_key
    @activity.created_at.to_i + @activity.id
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
      recipient_user_id =  target.user.id
      recipient_user_name = target.user.name
      recipient_name = target.name
      recipient_url = idea_path(target)
    elsif @activity.recipient_type == "User"
      recipient_user_id = @activity.recipient_id
      recipient_user_name =   target.name
      recipient_name = target.name
      recipient_url = profile_path(target)
    else
      recipient_user_id =  target.user.id
      recipient_user_name = target.user.name
      recipient_url = profile_activities_activity_path(target.user, find_activity_id)
      recipient_name = target.user.name
    end

    if !target.nil?
     badge_description = @activity.badge_description if @activity.badge_description.present?
      {
        recipient_user_id: recipient_user_id,
        recipient_user_name: recipient_user_name,
        recipient_url: recipient_url,
        recipient_name: recipient_name,
        badge_description: badge_description || nil,
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