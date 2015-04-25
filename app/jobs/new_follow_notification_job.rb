class NewFollowNotificationJob < ActiveJob::Base

  def perform(user, recipient)
    ActiveRecord::Base.connection_pool.with_connection do
      Pusher.trigger("private-user-#{recipient.id}", "new_notification", {data: {id: notification.id, msg: msg } }.to_json)
    end
  end

end
