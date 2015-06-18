class InviteTeamJob < ActiveJob::Base

  def perform(user_id, reciever_id, idea_id, msg)
    ActiveRecord::Base.connection_pool.with_connection do
      @idea = Idea.lock.find(idea_id)
      @user = User.find(user_id)
      @reciever = User.find(reciever_id)
      InviteMailer.invite_team(@reciever, @user, @idea, msg).deliver_later
      @idea.team_invites_ids.push(reciever_id)
      @idea.save
      CreateActivityJob.perform_later(@user.id, "TeamInvite")
    end
  end
end
