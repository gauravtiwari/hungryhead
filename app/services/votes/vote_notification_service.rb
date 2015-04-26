class VoteNotificationService

  def initialize(activity)
    @activity = activity
  end

  def notify
    @user = @activity.recipient_type == "Idea" ? @activity.recipient.student : @activity.recipient.user
    Pusher.trigger("private-user-#{@user.id}",
      "new_feed_item",
      {data:  @activity.user.latest_activities.last}
    )
  end

end