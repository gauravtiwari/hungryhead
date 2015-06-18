class JoinTeamJob < ActiveJob::Base

  def perform(invite_id)

    ActiveRecord::Base.connection_pool.with_connection do

      @team_invite = TeamInvite.find(invite_id)

      @idea = Idea.find(@team_invite.idea_id)

      @team_invite.pending = false
      @team_invite.save

      #Send mails to recipients
      InviteMailer.joined_team(@team_invite).deliver_later

      #Create an activity after invite
      if Notification.where(trackable: @team_invite, key: 'team_invite.joined').empty?
        CreateActivityJob.perform_later(@team_invite.id, @team_invite.class.to_s)
      end

    end
  end

end
