class JoinTeamJob < ActiveJob::Base

  def perform(user, rec_id, idea)
    ActiveRecord::Base.connection_pool.with_connection do
      if !idea.team.include? user.id.to_s
        idea.team.push(user.id.to_s)
        idea.team_invites.delete(user.id.to_s)
        idea.save

        msg = "<a href='#{Rails.application.routes.url_helpers.profile_path(user)}'>#{user.name}</a> has just joined "+ "<a href='#{Rails.application.routes.url_helpers.idea_path(idea)}'>#{idea.name}</a> team".html_safe

        Pusher.trigger("private-user-#{rec_id}", "new_notification", {data: {id: notification.id, msg: msg } }.to_json)
      else
        Pusher.trigger("private-user-#{user.uid}", "new_notification", {data: {id: notification.id, msg: "You are already in #{idea.name} team" } }.to_json)
      end
    end
  end

end
