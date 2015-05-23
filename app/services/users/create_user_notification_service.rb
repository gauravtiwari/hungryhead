class CreateUserNotificationService

  def initialize(user)
    @user = user
  end

  def create
    @user.activities.create!(
      trackable: @user,
      verb: 'joined',
      recipient: @user,
      key: 'user.create'
    )
  end

end