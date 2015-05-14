class CreateNoteNotificationService

  def initialize(post)
    @post = post
    @user = post.user
  end

  def create
    @activity = @user.activities.create!(
      trackable: @post,
      verb: 'posted',
      recipient: @user,
      key: 'post.create',
      unread: true
    )

    cache(@activity)
    PostNotificationJob.set(wait: 5.seconds).perform_later(@post.id, @user.id, @activity.id)
  end

  def cache(activity)
    CreateNotificationCacheService.new(activity).create
  end

end