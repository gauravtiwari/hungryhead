  class PublishIdeaJob < ActiveJob::Base

  def perform(idea, user, msg, plain_msg)
    ActiveRecord::Base.connection_pool.with_connection do
      # Send notifications to followers
      User.find(user.followers_ids.members).each do |f|
        notification = Notification.create!(
          reciever_id: f.id,
          sender_id: user.id,
          parameters: {
            verb: "published",
            trackable: idea.id,
            msg: msg,
            read: false
          }
        )

      Pusher.trigger_async("private-user-#{f.id}", "new_notification", {data: {id: notification.id, msg: msg } }.to_json)
      IdeaMailer.new_idea(idea, user, f, plain_msg).deliver_later
      end
    end
  end
end
