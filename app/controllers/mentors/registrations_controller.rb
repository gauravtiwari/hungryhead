class Mentors::RegistrationsController < Devise::RegistrationsController
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

  def edit
    super
  end

  def cancel
    super
  end

  def destroy
    super
  end

  private

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :school_id, :terms_accepted, :remember_me, :name) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me, :password_confirmation) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :terms_accepted, :username, :email,:user_type, :state, :role, :password, :password_confirmation, :current_password) }
  end

end
