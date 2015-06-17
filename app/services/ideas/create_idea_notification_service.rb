class CreateIdeaNotificationService

  def initialize(idea)
    @idea = idea
    @user = idea.user
  end

  def create
    if activity_empty?
      create_activity
    else
      publish_activity
    end
  end

  private

  #Check if activity exists for idea?
  def activity_empty?
    Activity.where(trackable_id: @idea.id, trackable_type: "Idea", key: 'idea.create').empty?
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
    PublishIdeaJob.perform_later(@idea.id, @user.id, @activity.id)
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