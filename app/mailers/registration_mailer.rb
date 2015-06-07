class RegistrationMailer < ActionMailer::Base

  default from: "no-reply@hungryhead.co"

  def welcome_email(user_id)
    @user = User.find(user_id)
    attachments.inline['hungryhead.png'] = File.read('assets/imageshungryhead.png')
    if @user.present?
      @subject = "#{@user.name}: Welcome to hungryhead"
      mail(to: @user.email, subject: @subject)
    else
      return false
    end
  end
end
