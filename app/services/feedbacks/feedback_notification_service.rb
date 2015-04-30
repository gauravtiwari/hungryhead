class FeedbackNotificationService

  def initialize(feedback)
    @feedback = feedback
    @idea = feedback.idea
    @user = feedback.user
  end

  def notify
    @activity = @user.activities.create!(trackable: @feedback, verb: 'feedbacked', recipient: @idea, key: 'feedback.create')
    FeedbackNotificationCacheService.new(@activity).cache
    send_notification(@activity)
  end

  private

  def send_notification(activity)
    Pusher.trigger_async("private-user-#{@idea.student.id}",
      "new_feed_item",
      {
        data:  activity.user.latest_notifications.last
      }.to_json
    )

    idea_notifcation(activity)
  end

  def idea_notification(activity)
    if activity.recipient_type == "Idea"
      Pusher.trigger_async("idea-feed-#{activity.recipient_id}",
        "new_feed_item",
        {
          data: activity.recipient.latest_notifications.last
        }.to_json
      )
    end
  end

end