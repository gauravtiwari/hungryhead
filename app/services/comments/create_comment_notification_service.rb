class CreateCommentNotificationService
  def initialize(comment)
    @comment = comment
    @user = comment.user
    @commentable = comment.commentable
  end

  def create
    if @user.activities.where(trackable: @comment).empty?
      @activity = @user.activities.create!(
        trackable: @comment,
        recipient: @commentable,
        parent_id: find_parent_activity,
        verb: 'commented',
        key: 'comment.create',
        is_notification: true
      )

      # Cache notification to user/followers feed
      CreateNotificationCacheService.new(@activity).create

      # Call mention service if any mentionable object is present?
      if @comment.body.scan(/@\w+/).present?
        CreateMentionService.new(@comment).mention
      end

    end
  end

  def find_parent_activity
    # Find parent activity
    @activity = Activity.where(trackable: @commentable).first
    # Increment parent score
    Activity.popular.incr(@activity.id, 5)
    @activity.uuid
  end
end
