class CommentNotificationService

	def initialize(comment, commentable)
		@comment = comment
		@user = comment.user
		@commentable = commentable
	end

	def notify
    @activity = @user.activities.create!(trackable: @comment, type: 'Notification', recipient: @commentable, verb: 'commented', key: 'comment.create')
	end

end