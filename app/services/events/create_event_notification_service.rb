class CreateShareNotificationService

  def initialize(event)
    @event = event
    @owner = event.owner
  end

  def create
    @activity = @owner.activities.create!(
      trackable: @event,
      verb: 'shared',
      recipient: @event,
      key: 'event.create',
      unread: true
    )
    cache(@activity)
  end

  def cache(activity)
    CreateNotificationCacheService.new(activity).create
  end

end