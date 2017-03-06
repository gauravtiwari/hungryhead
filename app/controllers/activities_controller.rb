class ActivitiesController < ApplicationController
  before_action :authenticate_user!, :set_user, :check_terms
  layout 'home'

  def index
    @user.update_attributes(feed_preferences: params[:type]) if params[:type]
    @activities = Activity.send(@user.feed_preferences).paginate(page: params[:page], per_page: 10)
  end

  def show
    @activity = Activity.find_by_uuid(params[:id])
    respond_to do |format|
      format.js
    end
  end

  private

  def set_user
    @user = current_user
  end
end
