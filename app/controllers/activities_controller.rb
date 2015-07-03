class ActivitiesController < ApplicationController

  before_action :authenticate_user!
  before_filter :check_terms
  layout "home"

  def index
    @activities = Activity.where(published: true)
        .includes([:trackable, :user])
        .order(id: :desc)
        .paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @activity = Activity.fetch_by_uuid(params[:id])
    respond_to do |format|
      format.js
    end
  end

end
