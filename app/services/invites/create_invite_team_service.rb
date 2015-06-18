class CreateInviteTeamService

  def initialize(reciever, current_user, idea, message)
    @reciever = reciever
    @current_user = current_user
    @idea = idea
    @message = message
  end

  def create
    @idea.team_invites.create!(
      inviter: current_user,
      invited: @reciever,
      idea: @idea,
      msg: message,
      token: Devise.friendly_token(24)
    )
  end

end