class UpdateNotificationCacheService

  def initialize(activity)
    @activity = activity #already persist in Postgres
    @actor = activity.owner
    @object = activity.trackable
    @target = activity.recipient
  end

  def update
    update_activity(@actor, activity)
  end

  protected

  def activity
    BuildActivityCacheBlobService.new(@activity).call
  end

  def find_activity_id
    if @activity.class.to_s == "Notification"
      return @activity.parent_id
    else
      return @activity.uuid
    end
  end

  def is_school?
    @activity.owner_type == "School"
  end

  #Get recipient user
  def recipient_user
    if @activity.recipient_type == "User"
      @activity.recipient
    elsif @activity.recipient_type == "Share" && is_school?
      @activity.recipient.owner.user
    elsif @activity.recipient_type == "Event" && is_school?
      @activity.recipient.owner.user
    elsif @activity.recipient_type == "Share" && !is_school?
      @activity.recipient.owner
    elsif @activity.recipient_type == "Event" && !is_school?
      @activity.recipient.owner
    else
      @activity.recipient.user
    end
  end

  #Get user and idea votes to send notifications
  def followers
    if @activity.recipient_type == "Idea"
      ids = @actor.followers_ids.union(@activity.recipient.voters_ids) - [recipient_user.id.to_s]
    elsif @activity.recipient_type == "School"
      ids = @actor.followers_ids.union(@activity.recipient.followers_ids) - [recipient_user.id.to_s]
    else
      ids = @actor.followers_ids.members - [recipient_user.id.to_s]
    end
    User.fetch_multi(ids)
  end

  #Update activity for all tickers
  def update_activity(user, activity_item)
    #add activity to user personal profile
    add_activity_to_user_profile(user, activity_item) unless is_school?
    #push notification into friends notifications
    add_notification_for_recipient(activity_item) unless @activity.owner == recipient_user && is_school?

    #Add activity to idea ticker if recipient or trackable is idea
    add_activity_to_idea(@object, activity_item) if @activity.trackable_type == "Idea"
    add_activity_to_idea(@target, activity_item) if @activity.recipient_type == "Idea"

    #add notification to followers ticker
    add_activity_to_followers(activity_item) if followers.any?
    #Add notification to commenters
    add_activity_to_commenters(activity_item) if @activity.trackable_type == "Comment"
  end

  #Add activity to idea ticker if recipient or trackable is idea
  def add_activity_to_idea(idea, activity_item)
    idea.ticker.remrangebyscore(score_key, score_key)
    idea.ticker.add(activity_item, score_key)
  end

  #Add notification to recipients
  def add_notification_for_recipient(activity_item)
    #delete from notifications
    recipient_user.friends_notifications.remrangebyscore(score_key, score_key)
    recipient_user.friends_notifications.add(activity_item, score_key)
    #delete from recipient ticker
    recipient_user.ticker.remrangebyscore(score_key, score_key)
    recipient_user.ticker.add(activity_item, score_key)
  end

  def add_activity_to_commenters(activity_item)
    @ids = @activity.recipient.commenters_ids.values - [@activity.owner_id.to_s, recipient_user.id.to_s] - @actor.followers_ids.members
    User.fetch_multi(@ids).each do |commenter|
      add_activity_to_friends_ticker(commenter, activity_item)
    end
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

end