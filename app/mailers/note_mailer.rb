class NoteMailer < ActionMailer::Base

  def new_idea(idea, user, recipient)
    @user = user
    @idea = idea
    @recipient = recipient
    @subject = "Your friend #{@user.name} shared a note - #{@note.title}"
    mail(:from => @user.email, :to => @recipient.email, :subject => @subject)
  end

end