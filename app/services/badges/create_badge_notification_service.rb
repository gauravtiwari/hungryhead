class CreateBadgeNotificationService

	def initialize(resource, description)
		@resource = resource
	end

	def create
    @activity = @user.notifications.create!(
      trackable: @resource,
      recipient: @resource,
      verb: 'badged',
      key: 'badge.create',
      unread: true
    )

    #Cache notification to user/followers feed
    CreateNotificationCacheService.new(@activity).create
	end

end