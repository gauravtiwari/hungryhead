class SendNotificationService

  def initialize(activity)
    @activity = activity
  end

  def user_notification
    Pusher.trigger_async("private-user-#{@activity.user.id}",
      "new_feed_item",
      {
        data:   @activity.user.latest_notifications.members.last
      }.to_json
    )
  end

  def idea_notification
    Pusher.trigger_async("idea-feed-#{@activity.recipient_id}",
      "new_feed_item",
      {
        data:  @activity.recipient.latest_notifications.members.last
      }.to_json
    )
  end

end