class AfterSignupController < ApplicationController
  include Wicked::Wizard
  before_filter :authenticate_user!, :user
  steps :getting_started, :complete_profile

  def show
    @user = current_user
    render_wizard
  end

  def update
    @user = current_user
    case step
    when :getting_started
      @user.update_attributes(user_params)
    when :complete_profile
      @user.update_attributes(user_params)
    end
    sign_in(@user, bypass: true)
    render_wizard @user
  end

  def finish_wizard_path
    profile_path(@user)
  end

  private

  def user_params
    params.require(:user).permit(:name, :password, :institution_id, :mini_bio, :market_list, :location_list, 
      :email, :terms_accepted, :username, :reset_password_token, :password_confirmation)
  end

  def user
    @user = current_user
  end

end
