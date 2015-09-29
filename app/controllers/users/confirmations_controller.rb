class Users::ConfirmationsController < Devise::ConfirmationsController
   # Remove the first skip_before_filter (:require_no_authentication) if you
  # don't want to enable logged users to access the confirmation page.
  skip_before_filter :require_no_authentication
  skip_before_filter :authenticate_user!
  layout 'join'

  def new
    super
  end
  # PUT /resource/confirmation
  def update
    super
  end

  def create
    super
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    super
  end

  def edit
    super
  end

  def destroy
    super
  end

end