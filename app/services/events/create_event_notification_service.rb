class CreateEventNotificationService

  def initialize(event)
    @event = event
    @user = event.user
  end

  def create
    @activity = @user.activities.create!(
      trackable: @event,
      verb: 'created',
      recipient: @user,
      key: 'event.create',
      unread: true
    )
    cache(@activity)
  end

  def cache(activity)
    CreateNotificationCacheService.new(activity).create
  end

end