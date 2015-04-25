class ShareNotificationService

  def initialize(share)
    @feedback = share
    @shareable = share.shareable
    @user = share.user
  end

  def notify
    @activity = @user.activities.create!(trackable: @share, recipient: @shareable)
    send_notification(@activity)
  end


  private

  def send_notification(activity)
    @user = @shareable.class.to_s == "Idea" ? @shareable.student : @shareable.user
    Pusher.trigger("private-user-#{@user.id}",
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