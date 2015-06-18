class InviteTeamJob < ActiveJob::Base

  def perform(user, reciever, idea, msg)
    ActiveRecord::Base.connection_pool.with_connection do
      if !idea.team_invites.include? reciever.id.to_s
        InviteMailer.invite_team(reciever, user, idea, msg).deliver_later
        idea.team_invites.push(reciever.id.to_s)
        idea.save

        msg = "<a href='#{Rails.application.routes.url_helpers.profile_path(user)}'>#{user.name}</a> invited you to <a href='#{Rails.application.routes.url_helpers.join_team_idea_path(idea)}'> join </a> "+ "<a href='#{Rails.application.routes.url_helpers.idea_path(idea)}'>#{idea.name}</a>".html_safe

        Pusher.trigger("presence-user-#{user.uid}", "new_notification", {data: {id: notification.id, msg: "Successfully invited #{reciever.name}" } }.to_json)
        Pusher.trigger("presence-user-#{reciever.uid}", "new_notification", {data: {id: notification.id, msg: msg } }.to_json)
      else
        Pusher.trigger("presence-user-#{user.uid}", "new_notification", {data: {msg: "You can't invite #{reciever.name}" } }.to_json)
      end
    end
  end
end
