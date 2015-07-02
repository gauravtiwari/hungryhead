class WelcomeController < ApplicationController

  include Wicked::Wizard

  before_filter :authenticate_user!, :set_user
  steps :hello, :complete_profile, :follow_friends, :quick_links

  layout "home"

  def show
    @welcome = current_user #for merit to avoid console errors
    @user = current_user
    case step
    when :hello

    when :follow_friends
      if @user.school_id.present?
        ids = User.published.where(school_id: @user.school_id).where.not(id: current_user.id).pluck(:id)
        ids.push(@user.invited_by.followings_ids.members) if @user.invited_by.present?
      elsif @user.invited_by.present?
        ids = @user.invited_by.followings_ids.members
      end
      if ids.empty?
        skip_step
      else
        @friends = User.published.find(ids).paginate(:page => params[:page], :per_page => 10)
      end
    when :quick_links

    end
    render_wizard
  end

  def update
    @welcome = current_user #for merit to avoid console errors
    @user = current_user
    case step
    when :complete_profile
      @user.update_attributes(user_params)
      CreateActivityJob.perform_later(@user.id, "User") if Activity.where(trackable: @user).empty?
    end
    sign_in(@user, bypass: true)
    render_wizard @user
  end

  private

  def user_params
    params.require(:user).permit(:rules_accepted)
  end

  def finish_wizard_path
    profile_path(@user)
  end

  def set_user
    @user = current_user
  end

end
