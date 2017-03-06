class UpdateNotificationCacheService
  # Duplicate class to be refactored

  def initialize(activity)
    @activity = activity.class.to_s.constantize.find(activity.id) # already persist in Postgres
    @actor = activity.user
    @object = activity.trackable
    @target = activity.recipient
  end

  def update
    # Send notification to recipient
    add_notification_for_recipient unless @activity.user == @activity.recipient_user
    # Add activity to followers friends_notifications
    add_activity_to_followers if followers.any?
    # Add notification to commenters
    add_activity_to_commenters if @activity.trackable_type == 'Comment'
  end

  protected

  # Get followers for users
  def followers
    if @activity.user_type == 'User' && @activity.key == 'vote.create'
      ids = (@actor.followers_ids.union(@activity.recipient.voters_ids) - [@activity.recipient_user.id.to_s])
    elsif @activity.user_type == 'School'
      ids = (@actor.followers_ids.union(@activity.recipient.followers_ids) + @actor.users.pluck(:id).map(&:to_s) - [@activity.recipient_user.id.to_s])
    else
      ids = (@actor.followers_ids.members - [@activity.recipient_user.id.to_s])
    end
    User.find(ids.uniq)
  end

  # add activity to recipient notifications
  def add_notification_for_recipient
    # add to notifications
    @activity.recipient_user.friends_notifications.remrangebyscore(score_key, score_key)
    @activity.recipient_user.friends_notifications.add(@activity.json_blob, score_key)
  end

  def add_activity_to_commenters
    @ids = @activity.recipient.commenters_ids.values - [@activity.user_id.to_s, @activity.recipient_user.id.to_s] - @actor.followers_ids.members
    User.find(@ids).each do |commenter|
      add_activity_to_friends_notifications(commenter)
    end
  end

  # add activity to friends friends_notifications
  def add_activity_to_friends_notifications(user)
    user.friends_notifications.remrangebyscore(score_key, score_key)
    user.friends_notifications.add(@activity.json_blob, score_key)
  end

  # Add activity to followers friends_notifications
  def add_activity_to_followers
    followers.each do |follower|
      add_activity_to_friends_notifications(follower)
      SendNotificationService.new(follower, @activity.json_blob).user_notification
    end
  end

  # generate redis key
  def score_key
    @activity.created_at.to_i + @activity.id
  end
end
