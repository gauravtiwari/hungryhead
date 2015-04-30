class CommentNotificationService

	def initialize(comment, commentable)
		@comment = comment
		@user = comment.user
		@commentable = commentable
	end

	def notify
    @activity = @user.notifications.create!(
      trackable: @comment,
      recipient: @commentable,
      verb: 'commented',
      key: 'comment.create'
    )
    CommentNotificationCacheService.new(@activity).cache
    send_notification(@activity)
	end

  private

  def send_notification(activity)
    commentable_user = @commentable.class.to_s == "Idea" ? @commentable.student.id : @commentable.user.id
    users = activity.recipient.commenters_ids.members.push(commentable_user)

    users.each do |user|
      Pusher.trigger_async("private-user-#{user}",
        "new_feed_item",
        {
          data: activity.user.latest_notifications.last
        }.to_json
      ) unless user == @user.id
    end

    idea_notification(activity) #Send notification to idea feed
  end

  def idea_notification(activity)
    if activity.recipient_type == "Idea"
      Pusher.trigger_async("idea-feed-#{activity.recipient_id}",
        "new_feed_item",
        {
          data: activity.recipient.latest_notifications.last
        }.to_json
      )
    end
  end

end