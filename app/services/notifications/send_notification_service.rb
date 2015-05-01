class SendNotificationService

  def initialize(recipient)
    @recipient = recipient
  end

  def user_notification
    Pusher.trigger_async("private-user-#{@recipient.id}",
      "new_feed_item",
      {
        data:   @recipient.latest_notifications.members.last
      }.to_json
    )
  end

  def idea_notification
    Pusher.trigger_async("idea-feed-#{@recipient.id}",
      "new_feed_item",
      {
        data:  @recipient.latest_notifications.members.last
      }.to_json
    )
  end

end