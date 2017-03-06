class Users::InvitationsController < Devise::InvitationsController
  before_filter :update_sanitized_params, only: :update
  respond_to :json, :html

  layout 'join'

  def new
    self.resource = resource_class.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  # PUT /resource/invitation
  def update
    invitation_token = Devise.token_generator.digest(
      resource_class, :invitation_token,
      update_resource_params[:invitation_token]
    )
    self.resource = resource_class.where(invitation_token: invitation_token).first
    respond_to do |format|
      format.js do
        resource.skip_password = true
        resource.update_attributes update_resource_params.except(:invitation_token)
      end
      format.html do
        super
      end
    end
  end

  def edit; end

  protected

  def update_sanitized_params
    devise_parameter_sanitizer.for(:accept_invitation) do |u|
      u.permit(:name, :password, :password_confirmation, :invitation_token,
               :username, :avatar, :avatar_cache)
    end
  end
end
