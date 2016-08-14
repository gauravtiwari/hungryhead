class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Pundit Authorization
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Devise Permitted paramaters
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Flash messages from rails
  after_action :prepare_unobtrusive_flash
  before_action :set_paper_trail_whodunnit

  # Device specific templates
  before_action :set_device_type

  before_action :set_current_user, if: :user_signed_in?

  protected

  def set_current_user
    User.current = current_user
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :first_name, :last_name, :name, :school_id, :terms_accepted, :remember_me, :name) }
    devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me, :password_confirmation) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :username, :terms_accepted, :email, :password, :password_confirmation, :current_password) }
    devise_parameter_sanitizer.permit(:accept_invitation) do |u|
      u.permit(:name, :password, :password_confirmation, :invitation_token)
    end
  end

  def render_forbidden
    flash[:notice] = "You are not authorized to access this page"
    if user_signed_in?
      redirect_to profile_path(current_user)
    else
      flash[:notice] = "Please login to access this page"
      redirect_to root_path
    end
  end

  def authenticate_admin_user!
    authenticate_user!
    unless current_user.admin?
      redirect_to root_path, alert: "This area is restricted to administrators only."
    end
  end

  def current_admin_user
    return nil if user_signed_in? && !current_user.admin?
    current_user
  end

  def check_logged_in
    redirect_to root_path, alert:  "You are already logged in" unless !user_signed_in?
  end

  def user_for_paper_trail
    user_signed_in? ? current_user.try(:id) : 'Unknown user'
  end

  def info_for_paper_trail
    {
      user_name: current_user.name,
      user_avatar: current_user.get_avatar,
      name_badge: current_user.name_badge,
      owner_url: profile_path(current_user)
    } if current_user
  end

  def check_terms
    if user_signed_in?  && !current_user.rules_accepted? && !current_user.admin?
      redirect_to(welcome_path(:complete_profile),
        notice: 'Welcome! Please accept terms to complete your registeration.')
    end
  end

  private

  #Error message if user not authorised
  def user_not_authorized
    if request.xhr?
      render json: {error: "Not found"}, :status => 404
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def set_device_type
    request.variant = :phone if browser.device.mobile?
    request.variant = :tablet if browser.device.tablet?
  end

end
