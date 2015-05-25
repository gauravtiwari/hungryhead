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

    #Cache notification to user/followers feed
    CreateNotificationCacheService.new(@activity).create
  end

end