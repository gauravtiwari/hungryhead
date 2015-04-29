class VoteNotificationService

  def initialize(activity)
    @activity = activity
  end

  def notify
    Pusher.trigger("private-user-#{@activity.user.id}",
      "new_feed_item",
      {
        data:  @activity
      }.to_json
    )
    if @activity.recipient_type == "Idea"
      Pusher.trigger_async("idea-feed-#{@activity.recipient_id}",
        "new_feed_item",
        {
          data: @activity
        }.to_json
      )
    end
  end

end