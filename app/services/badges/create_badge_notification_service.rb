class CreateBadgeNotificationService

	def initialize(user, description)
		@user = user
	end

	def create
    @activity = @user.notifications.create!(
      trackable: @user,
      recipient: @user,
      verb: 'badged',
      key: 'badge.create',
      badge_description: description,
      unread: true
    )

    #Cache notification to user/followers feed
    CreateNotificationCacheService.new(@activity).create
	end

end