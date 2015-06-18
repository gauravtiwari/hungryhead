class InviteMailer < ActionMailer::Base

  layout 'mailer'

  def invite_team(team_invite)
    @user = team_invite.invited
    @resource = team_invite.inviter
    @idea = team_invite.idea
    subject = "#{@resource.name} has invited you to join #{@idea.name}"
    @view_link = idea_url(@idea)
    @invitation_link = idea_team_invite_url(@idea.slug, team_invite.id, token: team_invite.token)
    mail(:from => @resource.email, :to => @user.email, :subject => subject)
  end

  def invite_friends(user, from)
    @invited = user
    @sender = from
    @token = @invited.raw_invitation_token
    subject = "#{@sender.name} has invited you to join hungryhead"
    @invitation_link = accept_user_invitation_url(:invitation_token => @token)
    mail(:from => @sender.email, :to => @invited.email, :subject => subject)
  end
end