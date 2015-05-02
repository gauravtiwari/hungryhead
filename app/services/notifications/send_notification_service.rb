class SendNotificationService

  def initialize(recipient, activity)
    @recipient = recipient
    @activity = activity
  end

  def user_notification
    Pusher.trigger_async("private-user-#{@recipient.id}",
      "new_feed_item",
      {
        data:   @recipient.latest_notifications.rangebyscore(@activity.created_at.to_i, activity.created_at.to_i)
      }.to_json
    )
  end

  def idea_notification
    Pusher.trigger_async("idea-feed-#{@recipient.id}",
      "new_feed_item",
      {
        data:  @recipient.latest_notifications.rangebyscore(@activity.created_at.to_i, activity.created_at.to_i)
      }.to_json
    )
  end

end