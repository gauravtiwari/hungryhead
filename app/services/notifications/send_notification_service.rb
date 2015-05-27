class SendNotificationService

  def initialize(recipient, activity)
    @recipient = recipient
    @activity = activity
  end

  def user_notification
    Pusher.trigger_async("private-user-#{@recipient.id}",
      "new_ticker_item",
      {
        data:   @activity
      }.to_json
    )
  end

  def friend_notification
    Pusher.trigger_async("private-user-#{@recipient.id}",
      "new_friend_notification_item",
      {
        data:   @activity
      }.to_json
    )
  end

  def idea_notification
    Pusher.trigger_async("idea-feed-#{@recipient.id}",
      "new_idea_ticker_item",
      {
        data:  @activity
      }.to_json
    )
  end

end