class SendNotificationService

  def initialize(recipient, html)
    @recipient = recipient
    @html = html
  end

  def user_notification
    Pusher.trigger_async("private-user-#{@recipient.uid}",
      "new_ticker_item",
      {
        data:   @html
      }.to_json
    )
    #Send counters updates
    Pusher.trigger_async("private-user-#{@recipient.uid}",
      "new_notifications_count",
      {
        data:   @recipient.notifications_counter.value
      }.to_json
    )
  end

  def idea_notification
    Pusher.trigger_async("idea-feed-#{@recipient.uuid}",
      "new_ticker_item",
      {
        data:   @html
      }.to_json
    )
  end

  def friend_notification
    Pusher.trigger_async("private-user-#{@recipient.uid}",
      "new_friend_notification_item",
      {
        data:   @html
      }.to_json
    )

    #send counters updates
    Pusher.trigger_async("private-user-#{@recipient.uid}",
      "new_notifications_count",
      {
        data:   @recipient.notifications_counter.value
      }.to_json
    )
  end

end