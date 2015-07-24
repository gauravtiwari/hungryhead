class CreateFollowNotificationService

	def initialize(follow)
		@follow = follow
    @user = follow.follower
    @followable = follow.followable
	end

  def create
    if @user.activities.where(trackable: @follow).empty?
      @activity = @user.activities.create!(
        trackable: @follow,
        verb: 'followed',
        recipient: @followable,
        key: 'follow.create',
        is_notification: true
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