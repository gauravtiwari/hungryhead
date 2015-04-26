class CommentNotificationService

	def initialize(comment, commentable)
		@comment = comment
		@user = comment.user
		@commentable = commentable
	end

	def notify
    @activity = @user.activities.create!(trackable: @comment, type: 'Notification', recipient: @commentable, verb: 'commented', key: 'create')
    send_notification(@activity)
	end

  private

  def send_notification(activity)
    activity.recipient.find_comments_for_commentable_without_current(activity.recipient_type, activity.recipient_id).each do |comment|
      Pusher.trigger("private-user-#{comment.user.id}",
        "new_feed_item",
        {data:
          {
            id: activity.id,
            item: ActivityPresenter.new(@activity, self)
          }
        }.to_json
      )
    end
  end

end