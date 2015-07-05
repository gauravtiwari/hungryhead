class ActivitiesController < ApplicationController

  before_action :authenticate_user!
  before_filter :check_terms
  layout "home"

  def index
    @activities = Activity.send(current_user.feed_preferences).paginate(:page => params[:page], :per_page => 10)
    @next_page_url = root_path(page: @activities.next_page)
  end

  def show
    @activity = Activity.fetch_by_uuid(params[:id])
    respond_to do |format|
      format.js
    end
  end

end
