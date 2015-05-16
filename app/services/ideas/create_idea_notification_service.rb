class CreateIdeaNotificationService

  def initialize(idea)
    @idea = idea
    @user = idea.student
  end

  def create
    if activity_exists?
      publish_activity
    else
      create_activity
    end
  end

  private

  #Check if activity exists for idea?
  def activity_exists?
    Activity.where(trackable_id: @idea.id, trackable_type: "Idea", key: 'idea.create').exists?
  end

  #Create activity if new idea
  def create_activity
    @activity = @user.activities.create!(
      trackable: @idea,
      recipient: @idea,
      key: 'idea.create',
      verb: 'pitched',
      unread: true
    )
    cache(@activity)
    PublishIdeaJob.set(wait: 15.seconds).perform_later(@idea.id, @user.id, @activity.id)
  end

  def cache(activity)
    CreateNotificationCacheService.new(activity).create
  end

  #Publish activity if activity exists?
  def publish_activity
    Activity.where(trackable_id: @idea.id, trackable_type: "Idea").find_each do |activity|
      if activity && !activity.published?
        activity.published = true
        activity.save
      end
    end
  end

end