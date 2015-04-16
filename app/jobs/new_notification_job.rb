class NewNotificationJob < ActiveJob::Base

  def perform(user, object, msg)
    recipient = object.class.to_s == "Idea" ? object.student : object.user
    
    notification = Notification.create!(
        reciever_id: recipient.id,
        sender_id: user.id,
        parameters: {
          verb: "liked",
          notifiable_type: object.class.to_s, 
          trackable: recipient.id,
          msg: msg,
          read: false
        }
    )

    Pusher.trigger("private-user-#{recipient.id}", "new_notification", {data: {id: notification.id, msg: msg } }.to_json)
  end
end
