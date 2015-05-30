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
    publish_user #publish user
  end

  def publish_user
    @user.published!
    @user.save
  end

end