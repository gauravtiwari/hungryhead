class IdeaMailer < ActionMailer::Base

  layout 'mailer'

  def new_idea(idea, user, recipient)
    @user = user
    @idea = idea
    @recipient = recipient
    @subject = "Your friend #{@user.name} pitched #{@idea.name}"
    mail(:from => @user.email, :to => @recipient.email, :subject => @subject)
  end

end