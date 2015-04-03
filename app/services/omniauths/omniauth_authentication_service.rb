class OmniauthAuthenticationService
  
  TEMP_EMAIL = "test@example.com"

  def initialize(params, omniauth = nil, signed_in_user = nil)
    @params = params
    @omniauth = omniauth
    @signed_in_user = signed_in_user
  end

  def find_or_create
    auth = Authentication.find_by_provider_and_uid(@omniauth[:provider], @omniauth[:uid])
    name = @omniauth[:info][:name]
    provider = @omniauth[:provider]
    uid = @omniauth[:uid]
    email = @omniauth[:info][:email]
    username = @omniauth[:info][:nickname] || generate_username(name)
    generated_password = Devise.friendly_token[0,20]

    if provider == "facebook"
      image = @omniauth[:info][:image].gsub('http://','https://')
      access_token = @omniauth[:credentials][:token]
    elsif provider == "twitter"
      image = @omniauth[:info][:image].sub("_normal", "")
      access_token = @omniauth[:credentials][:token]
      token_secret = @omniauth[:credentials][:secret]
    elsif provider == "linkedin"
      image = @omniauth[:extra][:raw_info][:pictureUrls][:values].first
    end

    @user = create_user(username, name, email, image, generated_password)
    @authentication = create_authentication(@user, uid, provider, access_token, token_secret)
    RegistrationMailer.welcome_email(@user, generated_password).deliver_later
    
    @user

  end

  def generate_username(name)
    username = name.parameterize
    if User.exists?(username: username)
      username + "-" + id
    else 
      username
    end
  end

  def create_user(username, name, email, image, password)
    @user = @signed_in_user ||
    email.present? && User.find_by_email(email) ||
    User.create!(
      username: username,
      name: name,
      location_list: @omniauth[:info][:location],
      email: email || TEMP_EMAIL,
      password: password,
      state: 1,
      confirmed_at: Time.now,
      remote_avatar_url: image,
      website_url: @omniauth[:info][:urls][:Facebook] || @omniauth[:info][:urls][:Twitter] || @omniauth[:info][:urls][:public_profile]
    )
  end

  def create_authentication(user, uid, provider, access_token, token_secret)
    @authentication = Authentication.create!(
      user: user,
      uid:      uid,
      provider: provider,
      access_token: access_token,
      token_secret: token_secret
    )
    @authentication
  end

end