class CommentNotificationService

	def initialize(comment, commentable)
		@comment = comment
		@user = comment.user
		@commentable = commentable
	end

	def notify
    @activity = @user.activities.create!(trackable: @comment, type: 'Notification', recipient: @commentable, verb: 'commented', key: 'comment.create')
    send_notification(@activity)
	end

  private

  def send_notification(activity)
    activity.recipient.comment_threads.each do |comment|
      Pusher.trigger("private-user-#{comment.user.id}",
        "new_feed_item",
        {data:
          {
            id: activity.id,
            item: ActivityPresenter.new(activity, self)
          }
        }.to_json
      ) unless @user == (@commentable.class.to_s == "Idea" ? @commentable.student : @commentable.user)
    end
  end

end