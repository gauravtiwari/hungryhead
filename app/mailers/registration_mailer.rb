class RegistrationMailer < ActionMailer::Base
  default from: "no-reply@hungryhead.co"
  def welcome_email(user, password)
    @user = user
    @password = password
    @url  = 'http://hungryhead.dev/login'
    mail(to: user.email, subject: 'Welcome to hungryhead')
  end
end
