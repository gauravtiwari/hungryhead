class IdeaMailer < ActionMailer::Base

  def new_idea(idea, user, recipient, subject)
    @user = user
    @idea = idea
    @recipient = recipient
    @subject = subject
    mail(:from => @user.email, :to => @recipient.email, :subject => @subject)
  end

end