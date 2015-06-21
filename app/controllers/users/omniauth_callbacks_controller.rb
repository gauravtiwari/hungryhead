class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  PROVIDERS = Devise.omniauth_providers

  PROVIDERS.each do |provider|
    define_method(provider) do
      auth = env['omniauth.auth']
      @user = OmniauthAuthenticationService.new(params, auth, current_user).find_or_create
      if @user.persisted?
        sign_in @user, :event => :authentication
        @user.remember_me = true
        redirect_to after_sign_in_path_for(@user)
      else
        session["devise.#{provider}_data"] = auth
        @user.remember_me = true
        redirect_to new_user_registration_url
      end
    end
  end

  private

  def after_sign_in_path_for(resource)
    sign_in_url = new_user_session_url
    if request.referer == sign_in_url
      super
    else
      stored_location_for(resource) || request.referer || root_path
    end
  end

end