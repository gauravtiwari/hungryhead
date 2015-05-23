class CreateBadgeNotificationService

	def initialize(user, description)
		@user = user
    @description = description
	end

	def create
    @activity = @user.notifications.create!(
      trackable: @user,
      recipient: @user,
      verb: 'badged',
      key: 'badge.create',
      badge_description: @description,
      unread: true
    )
	end

end