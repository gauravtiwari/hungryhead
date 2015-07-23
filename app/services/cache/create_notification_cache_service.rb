require 'render_anywhere'

class CreateNotificationCacheService

  include RenderAnywhere

  def initialize(activity)
    @activity = activity.class.to_s.constantize.find(activity.id) #already persist in Postgres
    @actor = activity.owner
    @object = activity.trackable
    @target = activity.recipient
  end

  def activity
    {
      id: @activity.id,
      verb: @activity.verb,
      activity_id: find_activity_id,
      type: @activity.class.to_s.downcase,
      html: build_html,
      created_at: "#{@activity.created_at.to_formatted_s(:iso8601)}"
    }
  end

  def create
    #Add activity to user profile
    add_activity_to_user_profile(@actor) unless is_school?

    #Send notification to recipient
    add_notification_for_recipient unless @activity.owner == recipient_user

    #Add activity to idea ticker if recipient or trackable is idea
    add_activity_to_idea(@object) if @activity.trackable_type == "Idea" && @activity.key == "idea.create"
    add_activity_to_idea(@target) if @activity.recipient_type == "Idea" && @activity.trackable_type != "idea.create"

    #Add activity to followers ticker
    add_activity_to_followers if followers.any?

    #Add notification to commenters
    add_activity_to_commenters if @activity.trackable_type == "Comment"
  end

  protected

  def build_html
    root ||= "#{@activity.class.to_s.downcase.pluralize}"
    path ||= @activity.key.to_s.gsub('.', '/')
    partial_path =  select_path path, root
    render :partial => partial_path, locals: {activity: @activity}
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
    User.find(ids)
  end

  #add activity to recipient notifications
  def add_notification_for_recipient
    #add to notifications
    recipient_user.friends_notifications.add(@activity.id, score_key)
    #add to ticker
    recipient_user.ticker.add(@activity.id, score_key)
    #Increment counter
    recipient_user.notifications_counter.increment
    SendNotificationService.new(recipient_user, build_html).user_notification if recipient_user != @activity.owner
    SendNotificationService.new(recipient_user, build_html).friend_notification if recipient_user != @activity.owner
  end

  #Add activity to idea ticker if recipient or trackable is idea
  def add_activity_to_idea(idea)
    idea.ticker.add(@activity.id, score_key)
    SendNotificationService.new(idea, build_html).idea_notification
  end

  #This is for user profile page to show latest personal activities
  def add_activity_to_user_profile(user)
    user.latest_activities.add(@activity.id, score_key)
  end

  def add_activity_to_commenters
    @ids = @activity.recipient.commenters_ids.values - [@activity.owner_id.to_s, recipient_user.id.to_s] - @actor.followers_ids.members
    User.find(@ids).each do |commenter|
      add_activity_to_friends_ticker(commenter)
      SendNotificationService.new(commenter, build_html).user_notification
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
      SendNotificationService.new(follower, build_html).user_notification
    end
  end

  #Get path for notifications or activities
  def select_path path, root
    [root, path].map(&:to_s).join('/')
  end

  #generate redis key
  def score_key
    @activity.created_at.to_i + @activity.id
  end

end