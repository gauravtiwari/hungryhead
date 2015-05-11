class Users::UserWelcomeService

  def initialize(resource, profile_url)
    @resource = resource
    @profile_url = profile_url
  end

  def welcome
    @resource.activities.create!(trackable: @resource, verb: 'joined', recipient: @resource, key: 'user.create')
  end

end