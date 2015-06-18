class JoinTeamJob < ActiveJob::Base

  def perform(invite_id)

    ActiveRecord::Base.connection_pool.with_connection do

      @team_invite = TeamInvite.find(invite_id)

      @idea = Idea.find(@team_invite.idea_id)

      unless @idea.team_invites_ids.include?(@team_invite.invited_id)
       @idea.team_ids.push(@team_invite.invited_id)
       @idea.team_invites_ids.delete(@team_invite.invited_id)
       @idea.save
      end

      #Send mails to recipients
      InviteMailer.joined_team(@team_invite).deliver_later
      #Create an activity after invite
      CreateActivityJob.perform_later(@team_invite.id, @team_invite.class.to_s)

      @team_invite.update_attribute(pending: false)
      @team_invite.save

    end
  end

end
