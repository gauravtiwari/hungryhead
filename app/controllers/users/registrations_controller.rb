class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters
  respond_to :json

  layout 'join'

  def new
      build_resource({})
      respond_with self.resource
  end

  def create
    @school_domain = School.find(params[:user][:school_id])
    if params[:user][:email].split('@').last == @school_domain.domain
      build_resource(sign_up_params)
      @user = resource

      #Skip confirmation for beta, // this needs to changed once we go live
      @user.skip_confirmation_notification!
      @user.save

      if @user.persisted?
        RegistrationMailer.welcome_email(@user.id).deliver_later(wait: 5.seconds)
        if Rails.env.production?
          meta_events_tracker.event!(:user, :signed_up, { :name => @user.name, :email => @user.email })
        end
        respond_with @user, location: after_sign_up_path_for(@user)
      else
        respond_with @user
      end
    else
      render :json =>  {
              error: "Your email doesn't match with your school email. Please verify and try again! If you don't have school email, please request an invite."
          }
    end
  end

  def edit
    super
  end

  def update
    @user = resource
    @registration = resource
    authorize @user
    @user.update_with_password(devise_parameter_sanitizer.sanitize(:account_update))
    if @user.encrypted_password_changed?
      set_flash_message :notice, :updated
      sign_in @user, :bypass => true
      render :edit
    else
      render "edit"
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :school_id, :terms_accepted, :remember_me, :name) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me, :password_confirmation) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :terms_accepted, :username, :email, :password, :password_confirmation, :current_password) }
  end

end
