class RegistrationMailer < ActionMailer::Base
  default from: "admin@hungryhead.org"
  def welcome_email(user, password)
    @user = user
    @password = password
    @url  = 'http://hungryhead.dev/login'
    mail(to: user.email, subject: 'Welcome to hungryhead')
  end
end
