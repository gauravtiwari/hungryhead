class CommentNotificationService

	def initialize(comment, commentable)
		@comment = comment
		@user = comment.user
		@commentable = commentable
	end

	def notify
    @activity = @user.notifications.create!(trackable: @comment, recipient: @commentable, verb: 'commented', key: 'comment.create')
    NotificationCacheService.new(@activity).cache
    send_notification(@activity)
	end

  private

  def send_notification(activity)
    commentable_user = @commentable.class.to_s == "Idea" ? @commentable.student : @commentable.user
    users = activity.recipient.commenters.push(commentable_user)
    users.each do |user|
      Pusher.trigger("private-user-#{user}",
        "new_feed_item",
        {
          data: activity.user.latest_notifications.last
        }
      )
    end
  end

end