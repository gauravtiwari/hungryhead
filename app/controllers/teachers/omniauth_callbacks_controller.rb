class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  PROVIDERS = Devise.omniauth_providers

  PROVIDERS.each do |provider|
    define_method(provider) do
      auth = env['omniauth.auth']
      authentication = Authentication.find_by_provider_and_uid(auth[:provider], auth[:uid])
      if authentication.present?
        if current_user.present? && authentication.user != @signed_in_user
          raise "Authenticated users mismatch: signed_in: #{ @signed_in_user.id }, auth: #{ authentication.user_id }"
        end
        @user = authentication.user
      else 
        @user = OmniauthAuthenticationService.new(params, auth, current_user).find_or_create
      end
    
      if @user.persisted?
        sign_in @user, :event => :authentication
        @user.remember_me = true
        if @user.sign_in_count == 1
          redirect_to after_signup_path(:getting_started)
        else
          redirect_to root_path
        end
      else
        session["devise.#{provider}_data"] = auth
        @user.remember_me = true
        redirect_to new_user_registration_url
      end
    end
  end

end