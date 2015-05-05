class CreateCommentNotificationService

	def initialize(comment)
		@comment = comment
		@user = comment.user
		@commentable = comment.commentable
	end

	def create
    @activity = @user.notifications.create!(
      trackable: @comment,
      recipient: @commentable,
      verb: 'commented',
      key: 'comment.create',
      unread: true
    )
    cache(@activity)
    mention if @comment.body.scan(/@\w+/).present?
	end

  def cache(activity)
    CreateNotificationCacheService.new(activity).create
  end

  def mention
    CreateMentionService.new(@comment).mention
  end

end