class FollowNotificationService

	def initialize(activity)
		@activity = activity
	end

	def notify
    @user = @activity.recipient_type == "Idea" ? @activity.recipient.student : @activity.recipient

    Pusher.trigger("private-user-#{@user.id}",
      "new_notification",
      {data:
        {
          id: @activity.id,
          msg: render(json: ActivityPresenter.new(@activity))
        }
      }.to_json
    )
	end

end