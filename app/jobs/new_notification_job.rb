class NewNotificationJob < ActiveJob::Base

  def perform(user, object, msg)
    recipient = object.class.to_s == "Idea" ? object.student : object.user
    Pusher.trigger("private-user-#{recipient.id}", "new_notification", {data: {id: notification.id, msg: msg } }.to_json)
  end
end
