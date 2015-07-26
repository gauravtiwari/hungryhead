class RegistrationMailerPreview < ActionMailer::Preview

  def welcome_email
    @user = User.find(2)
    if @user.present?
      RegistrationMailer.welcome_email(@user)
    else
      return false
    end
  end
end
