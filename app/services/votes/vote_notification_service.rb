class VoteNotificationService

  def initialize(activity)
    @activity = activity
  end

  def notify
    @user = @activity.recipient_type == "Idea" ? @activity.recipient.student : @activity.recipient.user
    Pusher.trigger("private-user-#{@user.id}",
      "new_notification",
      {data:
        {
          id: activity.id,
          msg: ActivityPresenter.new(@activity, self).render_activity
        }
      }.to_json
    )
  end

end