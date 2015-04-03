class NewFollowNotificationJob < ActiveJob::Base

  def perform(user, recipient)
    if recipient.class.name == "User"
      object_path = Rails.application.routes.url_helpers.profile_url(recipient,  host: 'localhost', port: 3000)
      object_name = 'You'
    elsif recipient.class.name == "Idea"
      object_path = Rails.application.routes.url_helpers.idea_url(recipient,  host: 'localhost', port: 3000)
      object_name = recipient.name
    end
    
    msg = "<a href='#{Rails.application.routes.url_helpers.profile_url(user, host: 'localhost', port: 3000)}'>#{user.name}</a> followed "+ "<a href='#{object_path}'>#{object_name}</a>".html_safe
    ActiveRecord::Base.connection_pool.with_connection do
      if recipient.class.name == "User"  

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
      elsif  recipient.class.name == "Idea"
   
        notification = Notification.create!(
          reciever_id: recipient.user.id,
          sender_id: user.id,
          parameters: {
            verb: "followed",
            trackable: recipient.user.id,
            msg: msg,
            read: false
          }
        )

        Pusher.trigger("private-user-#{recipient.user.id}", "new_notification", {data: {id: notification.id, msg: msg } }.to_json)
      end
    end
  end
end
