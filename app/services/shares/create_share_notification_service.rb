class CreateShareNotificationService

  def initialize(share)
    @share = share
    @shareable = share.shareable
    @user = share.user
  end

  def create
    @activity = @user.activities.create!(
      trackable: @share,
      verb: 'shared',
      recipient: @shareable,
      key: 'share.create',
      unread: true
    )
    cache(@activity)
  end

  def cache(activity)
    CreateNotificationCacheService.new(activity).create
  end

end