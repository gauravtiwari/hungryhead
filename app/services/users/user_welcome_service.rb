class Users::UserWelcomeService

  def initialize(resource, profile_url)
    @resource = resource
    @profile_url = profile_url
  end

  def welcome
    @resource.activities.create!(trackable: @resource, verb: 'joined', recipient: @resource, key: 'user.create')
    @resource.notifications.create!(trackable: @resource, verb: 'joined', recipient: @resource, key: 'user.create')
    AwardBadgeJob.set(wait: 5.seconds).perform_later(@resource.id, 1, "User_#{@resource.id}")
  end

end