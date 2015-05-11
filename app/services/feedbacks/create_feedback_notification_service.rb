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
    CreateNotificationCacheService.new(activity).create

    #Call mention service if any mentionable object is present?
    if @feedback.body.scan(/@\w+/).present?
      CreateMentionService.new(@feedback).mention
    end

    # Award badge if published first feedback
    if @user.first_feedback?
      #Add badge
    end

    # Award badge if published 30 feedbacks
    if @user.feedback_10?
      #Added badge
    end

  end

end