class CreateNotificationCacheService

  def initialize(activity)
    @activity = activity.class.to_s.constantize.find(activity.id) #already persist in Postgres
    @actor = activity.user
    @object = activity.trackable
    @target = activity.recipient
  end

  def create
    #Send notification to recipient
    unless  @activity.recipient_user.class.to_s == "School"
      add_notification_for_recipient unless @activity.user == @activity.recipient_user
    end

    #Add activity to idea ticker if recipient or trackable is idea
    add_activity_to_idea(@object) if @activity.trackable_type == "Idea"
    add_activity_to_idea(@target) if @activity.recipient_type == "Idea"
    #Add activity to followers ticker
    add_activity_to_followers if followers.any?
    #Add notification to commenters
    add_activity_to_commenters if @activity.trackable_type == "Comment"
  end

  protected

  def is_school?
    @activity.user_type == "School"
  end

  #Get followers for users and ideas
  def followers
    if @activity.recipient_type == "Idea"
      ids = (@actor.followers_ids.union(@activity.recipient.voters_ids) - [@activity.recipient_user.id.to_s]).uniq
    elsif @activity.recipient_type == "School"
      ids = (@actor.followers_ids.union(@activity.recipient.followers_ids) - [@activity.recipient_user.id.to_s]).uniq
    else
      ids = (@actor.followers_ids.members - [@activity.recipient_user.id.to_s]).uniq
    end
    User.find(ids)
  end

  #add activity to recipient notifications
  def add_notification_for_recipient
    #add to notifications
    @activity.recipient_user.friends_notifications.add(@activity.id, score_key)
    #add to ticker
    @activity.recipient_user.ticker.add(@activity.id, score_key)
    #Increment counter
    @activity.recipient_user.notifications_counter.increment
    SendNotificationService.new(@activity.recipient_user, @activity.json_blob).user_notification if @activity.recipient_user != @activity.user
    SendNotificationService.new(@activity.recipient_user, @activity.json_blob).friend_notification if @activity.recipient_user != @activity.user
  end

  #Add activity to idea ticker if recipient or trackable is idea
  def add_activity_to_idea(idea)
    idea.ticker.add(@activity.id, score_key)
    SendNotificationService.new(idea, @activity.json_blob).idea_notification
  end

  def add_activity_to_commenters
    @ids = @activity.recipient.commenters_ids.values - [@activity.user_id.to_s, @activity.recipient_user.id.to_s] - @actor.followers_ids.members
    User.find(@ids).each do |commenter|
      add_activity_to_friends_ticker(commenter)
      SendNotificationService.new(commenter, @activity.json_blob).user_notification
    end
  end

  #add activity to friends ticker
  def add_activity_to_friends_ticker(user)
    user.ticker.add(@activity.id, score_key)
  end

  #Add activity to followers ticker
  def add_activity_to_followers
    followers.each do |follower|
      add_activity_to_friends_ticker(follower)
      SendNotificationService.new(follower, @activity.json_blob).user_notification
    end
  end

  #generate redis key
  def score_key
    @activity.created_at.to_i + @activity.id
  end

end