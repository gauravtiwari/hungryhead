class PostFeedbackJob < ActiveJob::Base
  def perform(idea, user, msg)
    ActiveRecord::Base.connection_pool.with_connection do
      followers = idea.followers_ids.members.push(idea.student.id)
      all = followers.delete(user.id)
      if all
        User.find(all).each do |f|
          notification = Notification.create!(
                reciever_id: f,
                sender_id: user.id,
                parameters: {
                  verb: "feedbacked",
                  trackable: idea.id,
                  msg: msg,
                  read: false
                }
            )
        Pusher.trigger("private-user-#{f.id}", "new_notification", {data: {id: notification.id, msg: msg } }.to_json)
      end
    end

    end
  end
end
