class VoteNotificationService

  def initialize(activity)
    @activity = activity
  end

  def notify
    Pusher.trigger("private-user-#{@activity.user.id}",
      "new_feed_item",
      {
        data:  @activity.user.latest_notifications.last
      }
    )
  end

end