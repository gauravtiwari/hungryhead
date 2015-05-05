class CreateFeedbackNotificationService

  def initialize(feedback)
    @feedback = feedback
    @idea = feedback.idea
    @user = feedback.user
  end

  def create
    @activity = @user.activities.create!(
      trackable: @feedback,
      verb: 'feedbacked',
      recipient: @idea,
      key: 'feedback.create',
      unread: true
    )
    cache(@activity)
  end

  def cache(activity)
    CreateNotificationCacheService.new(activity).create
  end

end