class FeedbackNotificationService

  def initialize(feedback)
    @feedback = feedback
    @idea = feedback.idea
    @user = feedback.user
  end

  def notify
    @activity = @user.activities.create!(trackable: @feedback, verb: 'left a feedback for', recipient: @idea, key: 'feedback.create')
    send_notification(@activity)
  end

  private

  def send_notification(activity)
    Pusher.trigger("private-user-#{@idea.student.id}",
      "new_feed_item",
      {
        data:  activity.user.latest_notifications.last
      }.to_json
    )

    if activity.recipient_type == "Idea"
      Pusher.trigger_async("idea-feed-#{activity.recipient_id}",
        "new_feed_item",
        {
          data: activity
        }.to_json
      )
    end
  end

end