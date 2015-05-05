class CreateNoteNotificationService

  def initialize(note)
    @note = note
    @user = note.user
  end

  def create
    @activity = @user.activities.create!(
      trackable: @note,
      verb: 'noted',
      recipient: @user,
      key: 'note.create',
      unread: true
    )
    cache(@activity)
    NoteNotificationJob.set(wait: 5.seconds).perform_later(@note.id, @user.id, @activity.id)
  end

  def cache(activity)
    CreateNotificationCacheService.new(activity).create
  end

end