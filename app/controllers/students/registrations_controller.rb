class Students::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters
  respond_to :json

  layout 'join'

  def new
    build_resource({})
    respond_with self.resource
  end

  def create
    super
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :first_name, :last_name, :name, :school_id, :terms_accepted, :password_confirmation, :remember_me, :name) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me, :password_confirmation) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :terms_accepted, :username, :email,:user_type, :state, :role, :password, :password_confirmation, :current_password) }
  end

end
