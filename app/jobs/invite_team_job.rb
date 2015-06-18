class InviteTeamJob < ActiveJob::Base

  def perform(user_id, reciever_id, idea_id)
    ActiveRecord::Base.connection_pool.with_connection do
      @idea = Idea.find(idea_id)
      @user = User.find(user_id)
      @reciever = User.find(reciever_id)
      msg = "<a href='#{Rails.application.routes.url_helpers.profile_path(user)}'>#{user.name}</a> invited you to <a href='#{Rails.application.routes.url_helpers.join_team_idea_path(idea)}'> join </a> "+ "<a href='#{Rails.application.routes.url_helpers.idea_path(idea)}'>#{idea.name}</a>".html_safe
      InviteMailer.invite_team(@reciever, @user, @idea, msg).deliver_later
      @idea.team_invites_ids.push(reciever.id.to_s)
      @idea.save

      Pusher.trigger("presence-user-#{user.uid}", "new_notification", {data: {id: notification.id, msg: "Successfully invited #{reciever.name}" } }.to_json)
      Pusher.trigger("presence-user-#{reciever.uid}", "new_notification", {data: {id: notification.id, msg: msg } }.to_json)
    end
  end
end
