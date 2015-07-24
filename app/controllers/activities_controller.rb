class ActivitiesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_user
  before_filter :check_terms
  layout "home"

  def index
    if params[:type]
      @user.update_attributes(feed_preferences: params[:type])
    end
    @activities = Activity.send(@user.feed_preferences).paginate(:page => params[:page], :per_page => 10)
    @notifications = Activity.find(@user.ticker.revrange(0, 100)).paginate(:page => params[:page], :per_page => 20)
    @next_page_url = root_path(page: @activities.next_page)
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
