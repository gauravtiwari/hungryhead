class CreateFollowNotificationService

	def initialize(follow)
		@follow = follow
    @user = follow.follower
    @followable = follow.followable
	end

  def create
    if @user.notifications.where(trackable: @follow).empty?
      @activity = @user.notifications.create!(
        trackable: @follow,
        verb: 'followed',
        recipient: @followable,
        key: 'follow.create',
        unread: true
      )
      cache(@activity)
    else
      return
    end
  end

  def cache(activity)
    CreateNotificationCacheService.new(activity).create
  end

end