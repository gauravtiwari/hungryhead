class VoteNotificationService

  def initialize(user, vote, votable)
    @user = user
    @vote = vote
    @votable = votable
  end

  def notify
    @activity = @user.notifications.create!(trackable: @vote, recipient: @votable, verb: 'voted', key: 'vote.create')
    @voter = @votable.class.to_s == "Idea" ? @votable.student : @votable.user
    VoteNotificationCacheService.new(@activity).cache
    send_notification(@activity)
  end

  def send_notification(activity)
    Pusher.trigger_async("private-user-#{activity.user.id}",
      "new_feed_item",
      {
        data:   activity.user.latest_notifications.last
      }.to_json
    )

    idea_notification(activity)
  end

  def idea_notification(activity)
    if activity.recipient_type == "Idea"
      Pusher.trigger_async("idea-feed-#{activity.recipient_id}",
        "new_feed_item",
        {
          data:  activity.recipient.latest_notifications.last
        }.to_json
      )
    end
  end

end