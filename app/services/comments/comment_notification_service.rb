class CommentNotificationService

	def initialize(comment, commentable)
		@comment = comment
		@user = comment.user
		@commentable = commentable
	end

	def notify
    @activity = @user.notifications.create!(trackable: @comment, recipient: @commentable)
    send_notification(@activity)
	end

  def send_notification
    @activity.recipient.find_comments_for_commentable_without_current(@activity.recipient_type, @activity.recipient_id).each do |comment|
      Pusher.trigger("private-user-#{comment.user.id}",
        "new_notification",
        {data:
          {
            id: activity.id,
            msg: ActivityPresenter.new(@activity, self).render_activity
          }
        }.to_json
      )
    end
  end

end