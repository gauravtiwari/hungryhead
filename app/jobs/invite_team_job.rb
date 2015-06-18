class InviteTeamJob < ActiveJob::Base

  def perform(invite_id)
    ActiveRecord::Base.connection_pool.with_connection do
      @team_invite = TeamInvite.find(invite_id)

      #Save user_id cache into Idea table
      Idea.transaction do
        @idea = Idea.lock(true).find(@team_invite.idea_id)
        @idea.team_invites_ids.push(@team_invite.invited_id)
        @idea.save
      end

      #Send mails to recipients
      InviteMailer.invite_team(@team_invite).deliver_later
      #Create an activity after invite
      CreateActivityJob.perform_later(@team_invite.id, @team_invite.class.to_s)
    end
  end
end
