class ShareNotificationService

  def initialize(share)
    @share = share
    @shareable = share.shareable
    @user = share.user
  end

  def notify
    @activity = @user.activities.create!(trackable: @share, verb: 'shared', recipient: @shareable, key: 'share.create')
  end

end