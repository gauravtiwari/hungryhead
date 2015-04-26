class MentionNotificationService

	def initialize(activity)
		@activity = activity
	end

	def notify
    Pusher.trigger("private-user-#{@activity.recipient.id}",
      "new_feed_item",
      {data:
        {
          id: @activity.id,
          item: ActivityPresenter.new(@activity, self)
        }
      }.to_json
    )
	end

end