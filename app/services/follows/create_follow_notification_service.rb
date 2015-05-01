class CreateFollowNotificationService

	def initialize(follow)
		@follow = follow
    @user = follow.follower
    @followable = follow.followable
	end

  def create
    @activity = @user.notifications.create!(
      trackable: @follow,
      verb: 'followed',
      recipient: @followable,
      key: 'follow.create'
    )
    cache(@activity)
  end

  def cache(activity)
    CreateNotificationCacheService.new(activity).create
  end

end