class Students::RegistrationsController < Devise::RegistrationsController

  before_filter :configure_permitted_parameters
  respond_to :json

  layout 'join'

  def new
      build_resource({})
      respond_with self.resource
  end

  def create
    @school_domain = School.find(params[:student][:school_id])
    if params[:student][:email].split('@').last == @school_domain.domain
      build_resource(sign_up_params)
      @user = resource

      #Skip confirmation for beta, // this needs to changed once we go live
      @user.skip_confirmation_notification!
      @user.save

      if @user.persisted?
        RegistrationMailer.welcome_email(@user.id).deliver_later(wait: 5.seconds)
        respond_with @user, location: after_sign_up_path_for(@user)
      else
        respond_with @user
      end
    else
      flash[:error] = "Your email doesn't match with your school email. Please verify and try again!"
      render :json =>  {
              error: "Your email doesn't match with your school email. Please verify and try again!"
            }
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :first_name, :last_name, :name, :school_id, :terms_accepted, :password_confirmation, :remember_me, :name) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me, :password_confirmation) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :terms_accepted, :username, :email,:user_type, :state, :role, :password, :password_confirmation, :current_password) }
  end

end
