class CreateNotificationCacheService

  def initialize(activity)
    @activity = activity.class.to_s.constantize.find(activity.id) #already persist in Postgres
    @actor = activity.owner
    @object = activity.trackable
    @target = activity.recipient
  end

  def create
    add_activity(@actor, activity)
  end

  protected

  def activity
    BuildActivityCacheBlobService.new(@activity).call
  end

  def is_school?
    @activity.owner_type == "School"
  end

  #Find recipient user
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

  #Get followers for users and ideas
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

  #Add activity to different tickers
  def add_activity(user, activity_item)
    #Add activity to user profile
    add_activity_to_user_profile(user, activity_item) unless is_school?

    #Send notification to recipient
    add_notification_for_recipient(activity_item) unless @activity.user == recipient_user && is_school?

    #Add activity to idea ticker if recipient or trackable is idea
    add_activity_to_idea(@object, activity_item) if @activity.trackable_type == "Idea" && @activity.key == "idea.create"
    add_activity_to_idea(@target, activity_item) if @activity.recipient_type == "Idea" && @activity.trackable_type != "idea.create"

    #Add activity to followers ticker
    add_activity_to_followers(activity_item) if followers.any?

    #Add notification to commenters
    add_activity_to_commenters(activity_item) if @activity.trackable_type == "Comment"
  end

  #add activity to recipient notifications
  def add_notification_for_recipient(activity_item)
    #add to notifications
    recipient_user.friends_notifications.add(activity_item, score_key)
    #add to ticker
    recipient_user.ticker.add(activity_item, score_key)
    SendNotificationService.new(recipient_user, activity).user_notification if recipient_user != @activity.user
    SendNotificationService.new(recipient_user, activity).friend_notification if recipient_user != @activity.user
  end

  #Add activity to idea ticker if recipient or trackable is idea
  def add_activity_to_idea(idea, activity_item)
    idea.ticker.add(activity_item, score_key)
    SendNotificationService.new(idea, activity).idea_notification
  end

  #This is for user profile page to show latest personal activities
  def add_activity_to_user_profile(user, activity_item)
    user.latest_activities.add(activity_item, score_key)
  end

  def add_activity_to_commenters(activity_item)
    @ids = @activity.recipient.commenters_ids.values - [@activity.user_id.to_s, recipient_user.id.to_s] - @actor.followers_ids.members
    User.fetch_multi(@ids).each do |commenter|
      add_activity_to_friends_ticker(commenter, activity_item)
      SendNotificationService.new(commenter, activity).user_notification
    end
  end

  #add activity to friends ticker
  def add_activity_to_friends_ticker(user, activity_item)
    user.ticker.add(activity_item, score_key)
  end

  #Add activity to followers ticker
  def add_activity_to_followers(activity_item)
    followers.each do |follower|
      add_activity_to_friends_ticker(follower, activity_item)
      SendNotificationService.new(follower, activity).user_notification
    end
  end

  #generate redis key
  def score_key
    @activity.created_at.to_i + @activity.id
  end

end