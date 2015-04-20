class NewCommentNotificationJob < ActiveJob::Base

  def perform(user, object, msg)
    recipient = object.class.to_s == "Idea" ? object.student : object.user

    notification = Notification.create!(
      reciever_id: recipient.id,
      sender_id: user.id,
      parameters: {
        verb: "commented",
        notifiable_type: object.class.to_s,
        msg: msg,
        read: false
      }
    )
    Pusher.trigger("private-user-#{recipient.id}", "new_notification", {data: {id: notification.id, msg: msg } }.to_json)
  end
end
