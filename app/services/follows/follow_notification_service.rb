class FollowNotificationService

	def initialize(follow)
		@follow = follow
    @user = follow.follower
    @followable = follow.followable
	end

  def notify
    @activity = @user.activities.create!(trackable: @follow, verb: 'followed', type: 'Notification', recipient: @followable, key: 'follow.create')
  end

end