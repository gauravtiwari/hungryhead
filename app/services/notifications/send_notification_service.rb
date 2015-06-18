class SendNotificationService

  def initialize(recipient, activity)
    @recipient = recipient
    @activity = activity
  end

  def user_notification
    Pusher.trigger_async("presence-user-#{@recipient.uid}",
      "new_ticker_item",
      {
        data:   @activity
      }.to_json
    )
    #Send counters updates
    Pusher.trigger_async("presence-user-#{@recipient.uid}",
      "new_notifications_count",
      {
        data:   @recipient.unread_notifications
      }.to_json
    )
  end

  def friend_notification
    Pusher.trigger_async("presence-user-#{@recipient.uid}",
      "new_friend_notification_item",
      {
        data:   @activity
      }.to_json
    )

    #send counters updates
    Pusher.trigger_async("presence-user-#{@recipient.uid}",
      "new_notifications_count",
      {
        data:   @recipient.unread_notifications
      }.to_json
    )
  end

end