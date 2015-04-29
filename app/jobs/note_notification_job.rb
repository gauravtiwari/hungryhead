class NoteNotificationJob < ActiveJob::Base

  def perform(note_id, user_id, activity_id)
    ActiveRecord::Base.connection_pool.with_connection do
      #Fetch records
      @user = User.find(user_id)
      @note = Note.find(note_id)
      @activity = Activity.find(activity_id)
      # Send notifications to followers
      User.find(@user.followers_ids).each do |f|
        Pusher.trigger("private-user-#{f.id}",
          "new_feed_item",
          {data: @activity.user.latest_notifications.last}
        )
        #send mail to users if subscribed
        NoteMailer.new_note(@note, @user, f).deliver_later if f.note_notifications && f.note_notifications == true
      end
    end
  end

end
