class NoteNotificationJob < ActiveJob::Base

  def perform(note_id, user_id, activity_id)
    ActiveRecord::Base.connection_pool.with_connection do
      #Fetch records
      @user = User.find(user_id)
      @note = Note.find(note_id)
      @activity = Activity.find(activity_id)
      # Send notifications to followers
      User.find(@user.followers_ids.members).each do |f|
        #Calll notification service to deliver the notification to followers
        SendNotificationService.new(@user, @activity).user_notification
        #send mail to users if subscribed
        NoteMailer.new_note(@note, @user, f).deliver_later if f.note_notifications && f.note_notifications == true
      end
    end
  end

end
