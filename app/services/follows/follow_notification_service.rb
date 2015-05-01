class FollowNotificationService

	def initialize(follow)
		@follow = follow
    @user = follow.follower
    @followable = follow.followable
	end

  def notify
    @activity = @user.notifications.create!(trackable: @follow, verb: 'followed', recipient: @followable, key: 'follow.create')
    FollowNotificationCacheService.new(@activity).cache
    send_notification(@activity)
  end

  private

	def send_notification(activity)
    @user = activity.recipient_type == "Idea" ? activity.recipient.student : activity.recipient
    Pusher.trigger_async("private-user-#{@user.id}",
      "new_feed_item",
      {
        data: activity.user.latest_notifications.members.first
      }.to_json
    )

    idea_notification(activity) #send notification to idea
	end

  def idea_notification(activity)
    if activity.recipient_type == "Idea"
      Pusher.trigger_async("idea-feed-#{activity.recipient_id}",
        "new_feed_item",
        {
          data: activity.recipient.latest_notifications.members.first
        }.to_json
      )
    end
  end

end