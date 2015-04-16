class NewMentionNotificationJob < ActiveJob::Base

  def perform(user, recipient)

    notification = Notification.create!(
        reciever_id: recipient.id,
        sender_id: user.id,
        parameters: {
          verb: "mentioned",
          notifiable_type: "Mention", 
          trackable: recipient.id,
          msg: msg,
          read: false
        }
    )

    Pusher.trigger("private-user-#{recipient.id}", "new_notification", {data: {id: notification.id, msg: msg } }.to_json)
  end
end
