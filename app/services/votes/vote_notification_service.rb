class VoteNotificationService

  def initialize(user, vote, votable)
    @user = user
    @vote = vote
    @votable = votable
  end

  def notify
    @activity = @user.notifications.create!(trackable: @vote, recipient: @votable, verb: 'voted', key: 'vote.create')
    @voter = @votable.class.to_s == "Idea" ? @votable.student : @votable.user
    send_notification(@activity) if @user != @voter
  end

  def send_notification(activity)
    Pusher.trigger("private-user-#{activity.user.id}",
      "new_feed_item",
      {
        data:  activity
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