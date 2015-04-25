class MentionNotificationService

	def initialize(activity)
		@activity = activity
	end

	def notify
    Pusher.trigger("private-user-#{@activity.recipient.user.id}",
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