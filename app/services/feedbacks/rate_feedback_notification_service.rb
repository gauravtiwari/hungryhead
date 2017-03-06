class RateFeedbackNotificationService
  def initialize(user, feedback)
    @feedback = feedback
    @user = user
  end

  def create
    if @user.activities.where(trackable: @feedback).empty?
      @activity = @user.activities.create!(
        trackable: @feedback,
        verb: 'rated',
        recipient: @feedback,
        key: 'feedback.rate',
        is_notification: true,
        unread: true
      )

      # Cache notification to user/followers feed
      CreateNotificationCacheService.new(@activity).create
    end
  end
end
