class FollowNotificationService

	def initialize(follow)
		@follow = follow
    @user = follow.follower
    @followable = follow.followable
	end

  def notify
    @activity = @user.activities.create!(trackable: @follow, verb: 'followed', type: 'Notification', recipient: @followable, key: 'follow.create')
    send_notification(@activity)
  end

  private

	def send_notification(activity)
    @user = activity.recipient_type == "Idea" ? activity.recipient.student : activity.recipient
    Pusher.trigger("private-user-#{@user.id}",
      "new_feed_item",
      {data: activity.user.latest_notifications.last}
    )
	end

end