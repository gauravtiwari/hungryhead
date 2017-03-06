class InviteMailer < ActionMailer::Base
  def invite_team(team_invite)
    # Find inviter and invited
    @user = team_invite.invited
    @resource = team_invite.inviter
    # Find idea
    @idea = team_invite.idea
    @team_invite = team_invite
    # Set mail params
    subject = "#{@resource.name} has invited you to join #{@idea.name}"
    @view_link = idea_url(@idea)
    @invitation_link = idea_team_invite_url(@idea.slug, team_invite.id, token: team_invite.token)

    # Send mail
    mail(from: 'no-reply@hungryhead.co', to: @user.email, subject: subject)
  end

  def joined_team(team_invite)
    # Find inviter and invited
    @user = team_invite.inviter
    @resource = team_invite.invited
    # Find idea
    @idea = team_invite.idea
    @team_invite = team_invite

    # Set mail params
    subject = "#{@resource.name} have successfully joined #{@idea.name}"
    @view_link = idea_url(@idea)

    # Send mail
    mail(from: 'no-reply@hungryhead.co', to: @user.email, subject: subject)
  end

  def invite_friends(user, from)
    # Find inviter and user
    @invited = user
    @sender = from
    # Set token
    @token = @invited.raw_invitation_token

    #  Set mail params
    subject = "#{@sender.name} has invited you to join hungryhead"
    @invitation_link = accept_user_invitation_url(invitation_token: @token)

    #  Send mail
    mail(from: 'no-reply@hungryhead.co', to: @invited.email, subject: subject)
  end
end
