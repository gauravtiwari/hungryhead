class PublishIdeaService

  def initialize(idea, user)
    @idea = idea
    @user = user
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
    end
  end

  private

  #Create Activity if idea is new
  def create_activity
    @activity = @user.activities.create!(trackable: @idea, recipient: @idea, key: 'create', verb: 'pitched')
    PublishIdeaJob.set(wait: 15.seconds).perform_later(@idea.id, @user.id, @activity.id)
  end

  #Award Badge to user
  def award_badge
    @user.entrepreneur!
    AwardBadgeJob.set(wait: 10.seconds).perform_later(@user.id, 2, "Idea_#{@idea.id}")
  end

  #Publish activity if activity exists?
  def publish_activity
    Activity.where(trackable_id: @idea.id, trackable_type: "Idea").find_each do |activity|
      if activity && !activity.published?
        activity.published = true
        activity.save!
        true
      end
    end
  end

  #Check if activity exists for idea?
  def activity_exists?
    Activity.where(trackable_id: @idea.id, key: "create").exists?
  end

end