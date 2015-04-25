class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  protect_from_forgery with: :exception
  helper_method :xeditable?
  helper_method :search_content
  before_filter :configure_permitted_parameters, if: :devise_controller?

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :first_name, :last_name, :name, :school_id, :terms_accepted, :remember_me, :name) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me, :password_confirmation) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :username, :terms_accepted, :email, :password, :password_confirmation, :current_password) }
    devise_parameter_sanitizer.for(:accept_invitation) do |u|
      u.permit(:name, :password, :password_confirmation,
             :invitation_token)
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
    true
  end

  def authenticate_admin_user!
    authenticate_user!
    unless current_user.admin?
      flash[:alert] = "This area is restricted to administrators only."
      redirect_to root_path
    end
  end

  def current_admin_user
    return nil if user_signed_in? && !current_user.admin?
    current_user
  end

  def check_logged_in
    unless !user_signed_in?
      flash[:alert] = "You are already logged in"
      redirect_to root_path
    end
  end

  def info_for_paper_trail
    { user_name: current_user.name, user_avatar: current_user.avatar.url(:avatar), owner_url: user_path(current_user) } if current_user
  end

  def check_terms
    if user_signed_in? && !current_user.terms_accepted?
      redirect_to(after_signup_path(:getting_started), notice: "Please accept terms to get started")
    end
  end

  def track_activity(trackable, action = params[:action], type)
    current_user.activities.create! key: action, trackable: trackable, type: type
  end

  private

  def user_not_authorized
    if request.xhr?
      render json: {error: {message: "You are not authorized to perform this action"}}
    else
      redirect_to root_path
      flash[:notice] = "You are not authorized to perform this action"
    end
  end

end
