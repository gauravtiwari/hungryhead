class NoteMailer < ActionMailer::Base

  def new_note(note, user, recipient)
    @user = user
    @note = note
    @recipient = recipient
    @subject = "Your friend #{@user.name} shared a note - #{@note.title}"
    mail(:from => @user.email, :to => @recipient.email, :subject => @subject)
  end

end