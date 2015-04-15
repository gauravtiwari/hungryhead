class NewNotificationJob < ActiveJob::Base

  def perform(user, object, msg)
   
    notification = Notification.create!(
        reciever_id: object.user.id,
        sender_id: user.id,
        parameters: {
          verb: "liked",
          notifiable_type: object.class.to_s, 
          trackable: object.user.id,
          msg: msg,
          read: false
        }
    )

    Pusher.trigger("private-user-#{object.user.id}", "new_notification", {data: {id: notification.id, msg: msg } }.to_json)
  end
end
