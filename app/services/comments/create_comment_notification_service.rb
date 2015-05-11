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

    #Cache notification to user/followers feed
    CreateNotificationCacheService.new(activity).create

    #Call mention service if any mentionable object is present?
    if @comment.body.scan(/@\w+/).present?
      CreateMentionService.new(@comment).mention
    end

    # Award badge if published 30 comments
    if @user.comments_30?
      #added badge
    end

	end

end