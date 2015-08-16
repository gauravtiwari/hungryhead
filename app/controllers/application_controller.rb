class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  ensure_security_headers(
    :hsts             => {:max_age => 631138519, :include_subdomains => false},
    :x_xss_protection => {:value => 1, :mode => 'block'},
    :x_content_type_options => {:value => 'nosniff'},
    :x_download_options => {:value => 'noopen'},
    :x_permitted_cross_domain_policies => {:value => 'none'},
    :x_frame_options => 'DENY',
    :csp => false
  )

  # Pundit Authorization
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  #Devise Permitted paramaters
  before_filter :configure_permitted_parameters, if: :devise_controller?

  #Device specific templates
  before_action :set_device_type
  before_filter :set_current_user, if: :user_signed_in?
  before_filter :outdated_browser, if: :browser_outdated?

  protected

  def browser_outdated?
    browser.ie? && !browser.modern?
  end

  def outdated_browser
    redirect_to upgrade_path, notice: 'Your browser is outdated'
  end

  def set_current_user
    User.current = current_user
  end

  def track_visitor_events
    meta_events_tracker.event!(:visitor, :page_viewed, { :ip => request.ip, :title => params[:action].humanize.capitalize })
  end

  def meta_events_tracker
    @meta_events_tracker ||= MetaEvents::Tracker.new(current_user.try(:id), request.remote_ip)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :first_name, :last_name, :name, :school_id, :terms_accepted, :remember_me, :name) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me, :password_confirmation) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :username, :terms_accepted, :email, :password, :password_confirmation, :current_password) }
    devise_parameter_sanitizer.for(:accept_invitation) do |u|
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
    true
  end

  def authenticate_admin_user!
    authenticate_user!
    redirect_to root_path, alert: "This area is restricted to administrators only." unless current_user.admin?
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
      redirect_to(welcome_path(:complete_profile), notice: 'Welcome! Please accept terms to complete your registeration.')
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
    request.variant = :phone if browser.mobile?
    request.variant = :tablet if browser.tablet?
  end

end
