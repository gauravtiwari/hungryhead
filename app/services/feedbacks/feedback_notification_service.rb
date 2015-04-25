class FeedbackNotificationService

  def initialize(feedback)
    @feedback = feedback
    @idea = feedback.idea
    @user = feedback.user
  end

  def notify
    @activity = @user.activities.create!(trackable: @feedback, recipient: @idea)
    send_notification(@activity)
  end


  private

  def send_notification(activity)
    Pusher.trigger("private-user-#{@idea.student.id}",
      "new_notification",
      {data:
        {
          id: activity.id,
          msg: ActivityPresenter.new(activity, self).render_activity
        }
      }.to_json
    )
  end

end