class FollowNotificationService

	def initialize(activity)
		@activity = activity
	end

	def notify
    @user = @activity.recipient_type == "Idea" ? @activity.recipient.student : @activity.recipient

    Pusher.trigger("private-user-#{@user.id}",
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