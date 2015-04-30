class MentionNotificationService

	def initialize(activity)
		@activity = activity
	end

	def notify
    Pusher.trigger_async("private-user-#{@activity.recipient.id}",
      "new_feed_item",
      {
        data: @activity.user.latest_notifications.last
      }.to_json
    )
	end

end