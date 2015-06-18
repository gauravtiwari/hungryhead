class InviteTeamJob < ActiveJob::Base

  def perform(invite_id)
    ActiveRecord::Base.connection_pool.with_connection do
      @team_invite = TeamInvite.find(invite_id)
      InviteMailer.invite_team(@team_invite).deliver_later
      Idea.transaction do
        @idea = Idea.lock.find(@team_invite.idea_id)
        @idea.team_invites_ids.push(reciever_id)
        @idea.save
      end
      CreateActivityJob.perform_later(@team_invite.id, @team_invite.class.to_s)
    end
  end
end
