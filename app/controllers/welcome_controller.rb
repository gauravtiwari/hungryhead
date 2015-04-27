class WelcomeController < ApplicationController
  include Wicked::Wizard
  before_filter :authenticate_user!, :user
  steps :hello, :follow_friends
  layout "home"

  def show
    @user = current_user
    case step
    when :complete_profile
      @user.update_attributes(user_params)
    end
    render_wizard
  end

  def update
    @user = current_user
    case step
    when :hello
      @user.update_attributes(user_params)
    end
    sign_in(@user, bypass: true)
    render_wizard @user
  end

  private

  def user_params
    params.require(:user).permit(:rules_accepted)
  end

  def finish_wizard_path
    user_path(@user)
  end

  def user
    @user = current_user
  end

end
