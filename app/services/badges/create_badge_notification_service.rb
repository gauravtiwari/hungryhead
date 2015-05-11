class CreateBadgeNotificationService

	def initialize(badge)
		@badge = badge
		@badgeable = badge.badgeable
    @user = badge.user
	end

	def create
    @activity = @user.notifications.create!(
      trackable: @badge,
      recipient: @badgeable,
      verb: 'badged',
      key: 'badge.create',
      unread: true
    )

    #Cache notification to user/followers feed
    CreateNotificationCacheService.new(@activity).create
	end

end