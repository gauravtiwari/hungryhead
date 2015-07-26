class CreateShareNotificationService

  def initialize(share)
    @share = share
    @owner = share.owner
  end

  def create
    @activity = @owner.activities.create!(
      trackable: @share,
      verb: 'shared',
      recipient: @share,
      key: 'share.create',
      unread: true
    )
    cache(@activity)
  end

  def cache(activity)
    CreateNotificationCacheService.new(activity).create
  end

end