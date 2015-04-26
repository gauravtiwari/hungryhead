class FeedbackNotificationService

  def initialize(feedback)
    @feedback = feedback
    @idea = feedback.idea
    @user = feedback.user
  end

  def notify
    @activity = @user.activities.create!(trackable: @feedback, verb: 'feedbacked', recipient: @idea, key: 'feedback.create')
    send_notification(@activity)
  end


  private

  def send_notification(activity)
    Pusher.trigger("private-user-#{@idea.student.id}",
      "new_feed_item",
      {data:  activity.user.latest_activities.last }
    )
  end

end