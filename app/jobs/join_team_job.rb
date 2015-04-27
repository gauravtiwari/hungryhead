class JoinTeamJob < ActiveJob::Base

  def perform(user, rec_id, idea)
    ActiveRecord::Base.connection_pool.with_connection do
      if !idea.team.include? user.id.to_s
        idea.team.push(user.id.to_s)
        idea.team_invites.delete(user.id.to_s)
        idea.save

        msg = "<a href='#{Rails.application.routes.url_helpers.user_path(user)}'>#{user.name}</a> has just joined "+ "<a href='#{Rails.application.routes.url_helpers.idea_path(idea)}'>#{idea.name}</a> team".html_safe

        notification = Notification.create!(
            reciever_id: rec_id,
            sender_id: user.id,
            parameters: {
              verb: "team invite",
              trackable: rec_id,
              msg: msg,
              read: false
            }
        )

        Pusher.trigger("private-user-#{rec_id}", "new_notification", {data: {id: notification.id, msg: msg } }.to_json)
      else
        Pusher.trigger("private-user-#{user.id}", "new_notification", {data: {id: notification.id, msg: "You are already in #{idea.name} team" } }.to_json)
      end
    end
  end

end
