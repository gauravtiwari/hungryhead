class CreateNotificationCacheService

  def initialize(activity)
    @activity = activity.class.to_s.constantize.find(activity.id) #already persist in Postgres
    @actor = activity.owner
    @object = activity.trackable
    @target = activity.recipient
  end

  def create
    #Add activity to user profile
    add_activity_to_user_profile(@actor) unless is_school?

    #Send notification to recipient
    add_notification_for_recipient unless @activity.owner == @activity.recipient_user

    #Add activity to idea ticker if recipient or trackable is idea
    add_activity_to_idea(@object) if @activity.trackable_type == "Idea" && @activity.key == "idea.create"
    add_activity_to_idea(@target) if @activity.recipient_type == "Idea" && @activity.trackable_type != "idea.create"

    #Add activity to followers ticker
    add_activity_to_followers if followers.any?

    #Add notification to commenters
    add_activity_to_commenters if @activity.trackable_type == "Comment"
  end

  protected

  def is_school?
    @activity.owner_type == "School"
  end

  #Get followers for users and ideas
  def followers
    if @activity.recipient_type == "Idea"
      ids = @actor.followers_ids.union(@activity.recipient.voters_ids) - [@activity.recipient_user.id.to_s]
    elsif @activity.recipient_type == "School"
      ids = @actor.followers_ids.union(@activity.recipient.followers_ids) - [@activity.recipient_user.id.to_s]
    else
      ids = @actor.followers_ids.members - [@activity.recipient_user.id.to_s]
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
    SendNotificationService.new(@activity.recipient_user, @activity.json_blob).user_notification if @activity.recipient_user != @activity.owner
    SendNotificationService.new(@activity.recipient_user, @activity.json_blob).friend_notification if @activity.recipient_user != @activity.owner
  end

  #Add activity to idea ticker if recipient or trackable is idea
  def add_activity_to_idea(idea)
    idea.ticker.add(@activity.id, score_key)
    SendNotificationService.new(idea, @activity.json_blob).idea_notification
  end

  #This is for user profile page to show latest personal activities
  def add_activity_to_user_profile(user)
    user.latest_activities.add(@activity.id, score_key)
  end

  def add_activity_to_commenters
    @ids = @activity.recipient.commenters_ids.values - [@activity.owner_id.to_s, @activity.recipient_user.id.to_s] - @actor.followers_ids.members
    User.find(@ids).each do |commenter|
      add_activity_to_friends_ticker(commenter)
      SendNotificationService.new(commenter, @activity.json_blob).user_notification
    end
  end

  #add activity to friends ticker
  def add_activity_to_friends_ticker(user)
    user.ticker.add(@activity.id, score_key)
    #increment notification counter
    user.notifications_counter.increment
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