class UserWelcomeService

  def initialize(user)
    @user = user
  end

  def welcome
    @user.activities.create!(
      trackable: @user,
      verb: 'joined',
      recipient: @user,
      key: 'user.create'
    )
  end

end