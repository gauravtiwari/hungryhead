class UpdateTeamInviteService
  def initialize(team_invite)
    @team_invite = team_invite
  end

  def update_team_invite
    @team_invite.token = Devise.friendly_token(24)
    @team_invite
  end

  def join_team_invite
    @team_invite.pending = false
    @team_invite
  end
end
