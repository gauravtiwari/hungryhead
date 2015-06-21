module SocialAuthenticable

  extend ActiveSupport::Concern

  module ClassMethods

    def find_or_create_for_oauth(info, signed_in_user = nil)
      auth = Authentication.find_by_provider_and_uid(info["provider"], info["uid"])
      name = info['info']['name']
      provider = info["provider"]
      uid = info["uid"]

      image = info['info']['image'].sub("_normal", "")
      access_token = info['credentials']['token']
      token_secret = info['credentials']['secret']

      if auth.present?
        if signed_in_user.present? && auth.user != signed_in_user
          raise "Authenticated users mismatch: signed_in: #{ signed_in_user.id }, auth: #{ auth.user_id }"
        end
        @user = auth.user
        return auth.user
      end
      generated_password = Devise.friendly_token[0,20]

      user = signed_in_user ||
        info["info"]["email"].present? && User.find_by_email(info["info"]["email"]) ||
        User.create!(username: info["info"]["nickname"],
                     name: name,
                     email: TEMP_EMAIL,
                     password: generated_password,
                     remote_avatar_url: image,
                     confirmed_at: Time.now)

      Authentication.create! user:     user,
        uid:      uid,
        provider: provider,
        access_token: access_token,
        token_secret: token_secret

      RegistrationMailer.welcome_email(user).deliver
      user
    end

  end
end