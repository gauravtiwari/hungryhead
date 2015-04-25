class NewFollowNotificationJob < ActiveJob::Base

  def perform(user, recipient, user_path)

    msg = "<a href='#{user_path}'>#{user.name}</a> followed "+ "You".html_safe

    ActiveRecord::Base.connection_pool.with_connection do
      if recipient.class.to_s == "User"

        notification = Notification.create!(
          reciever_id: recipient.id,
          sender_id: user.id,
          parameters: {
            verb: "followed",
            trackable: recipient.id,
            msg: msg,
            read: false
          }
        )

      Pusher.trigger("private-user-#{recipient.id}", "new_notification", {data: {id: notification.id, msg: msg } }.to_json)
      elsif  recipient.class.to_s == "Idea"

        notification = Notification.create!(
          reciever_id: recipient.student.id,
          sender_id: user.id,
          parameters: {
            verb: "followed",
            trackable: recipient.student.id,
            msg: msg,
            read: false
          }
        )

        Pusher.trigger("private-user-#{recipient.student.id}", "new_notification", {data: {id: notification.id, msg: msg } }.to_json)
      end
    end
  end
end
