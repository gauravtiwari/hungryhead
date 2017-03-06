class RegistrationMailer < ActionMailer::Base
  def welcome_email(user_id)
    @user = User.find(user_id)
    if @user.present?
      #  Send welcome email
      @subject = "#{@user.name}: Welcome to hungryhead"
      mail(to: @user.email, subject: @subject)
    else
      return false
    end
  end
end
