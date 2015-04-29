class NoteNotificationService

  def initialize(note, user)
    @note = note
    @user = user
  end

  def notify
    @activity = @user.activities.create!(trackable: @note, verb: 'noted', recipient: @user, key: 'note.create')
    @user.notifications.create!(trackable: @note, verb: 'noted', recipient: @user, key: 'note.create')
    NoteNotificationJob.set(wait: 10.seconds).perform_later(@note.id, @user.id, @activity.id)
  end

end