class CreateTeamInviteNotificationService

  def initialize(team_invite)
    @team_invite = team_invite
    @inviter = team_invite.inviter
    @invited = team_invite.invited
    @idea = team_invite.idea
  end

  def create
    @activity = @inviter.notifications.create!(
      trackable: @team_invite,
      verb: 'invited',
      recipient: @invited,
      key: 'team_invite.create',
      unread: true
    )
    cache(@activity)
  end

  def cache(activity)
    CreateNotificationCacheService.new(activity).create
  end

end