class RegistrationMailer < ActionMailer::Base

  default from: "no-reply@hungryhead.co"

  def welcome_email(user_id)
    @user = User.find(user_id)
    if user.present?
      @subject = "#{@user.name}: Welcome to hungryhead"
      mail(to: @user.email, subject: @subject)
    else
      return false
    end
  end
end
