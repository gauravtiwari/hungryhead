class Users::SessionsController < Devise::SessionsController
  respond_to :json

  layout 'join'

  def new
    super
  end

  def edit
    super
  end

  def create
    self.resource = warden.authenticate!(auth_options)
    @session = resource
    set_flash_message(:notice, :signed_in) if is_flashing_format?
    sign_in(resource_name, resource)
    yield resource if block_given?
    render json: { location: after_sign_in_path_for(resource) }
  end

  def destroy
    super
  end

  private

  def after_sign_in_path_for(resource)
    sign_in_url = new_user_session_url
    if request.referer == sign_in_url && resource.sign_in_count != 1
      super
    elsif resource.sign_in_count == 1 && !resource.rules_accepted?
      welcome_path(:hello)
    else
      stored_location_for(resource) || request.referer || root_path
    end
  end
end
