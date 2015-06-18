class CreateTeamInviteService

  def initialize(reciever, current_user, idea, message)
    @reciever = reciever
    @current_user = current_user
    @idea = idea
    @message = message
  end

  def create
    @team_invite = @idea.team_invites.new(
      inviter: @current_user,
      invited: @reciever,
      idea: @idea,
      msg: @message,
      token: Devise.friendly_token(24)
    )
    @team_invite
  end

end