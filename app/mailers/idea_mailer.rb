class IdeaMailer < ActionMailer::Base

  layout 'mailer'

  def new_idea(idea, user, recipient)
    @user = user
    @idea = idea
    @recipient = recipient
    @subject = "Your friend #{@user.name} has pitched #{@idea.name}"
    mail(:from => 'no-reply@hungryhead.co', :to => @recipient.email, :subject => @subject)
  end

end