class ShareNotificationService

  def initialize(share)
    @share = share
    @shareable = share.shareable
    @user = share.user
  end

  def notify
    @activity = @user.activities.create!(trackable: @share, verb: 'shared', recipient: @shareable, key: 'share.create')
    NotificationCacheService.new(@activity).cache
    send_notification(@activity)
  end

  private

  def send_notification(activity)
    @user = @shareable.class.to_s == "Idea" ? @shareable.student : @shareable.user
    Pusher.trigger("private-user-#{@user.id}",
      "new_feed_item",
      {
        data: activity
      }.to_json
    )
    if activity.recipient_type == "Idea"
      Pusher.trigger_async("idea-feed-#{activity.recipient_id}",
        "new_feed_item",
        {
          data: activity
        }.to_json
      )
    end
  end

end