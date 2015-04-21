class PublishIdeaService

  def initialize(idea, user, idea_url, user_url)
    @idea = idea
    @user = user
    @idea_url = idea_url
    @user_url = user_url
  end

  def publish
    @idea.published!
    @idea.everyone!

    #If user not entrepreneur award badge
    if !@user.entrepreneur?
      award_badge
    end

    #Publish activity if user is already entrepreneur
    if activity_exists?
      publish_activity
    else
      create_activity
      send_notification
    end
  end

  private

  #Create Activity if idea is new
  def create_activity
    @idea.create_activity(
      key: 'idea.create',
      owner: @user,
      recipient: @idea,
      params: {verb: "pitched #{@idea.name}", action:  "an idea"}
    )
  end

  #Award Badge to user
  def award_badge
    @user.entrepreneur!
    AwardBadgeJob.set(wait: 10.seconds).perform_later(@user, @user, 2, "Idea_#{@idea.id}")
  end

  #Send notification to followers of user
  def send_notification
    PublishIdeaJob.set(wait: 15.seconds).perform_later(@idea, @user, msg, plain_msg)
  end

  #Publish activity if activity exists?
  def publish_activity
    PublicActivity::Activity.where(trackable_id: @idea.id, trackable_type: "Idea").find_each do |activity|
      if activity && !activity.published?
        activity.published = true
        activity.save!
        true
      end
    end
  end

  #Check if activity exists for idea?
  def activity_exists?
    PublicActivity::Activity.where(trackable_id: @idea.id, key: "idea.create").exists?
  end

  #Construct msg to send in notification
  def msg
    "<a href='#{@user_url}'>#{@user.name}</a> pitched <i class='fa fa-fw ion-briefcase'></i> "+ "<a href='#{@idea_url}'>#{@idea.name}</a>".html_safe
  end

  def plain_msg
    "Your friend #{@user.name} pitched #{@idea.name}"
  end

end