class VoteNotificationService

  def initialize(activity)
    @activity = activity
  end

  def notify
    @user = @activity.recipient_type == "Idea" ? @activity.recipient.student : @activity.recipient.user
  end

end