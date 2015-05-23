class ActivitiesController < ApplicationController

  before_action :authenticate_user!
  before_action :find_user, only: [:show]
  before_filter :check_terms

  layout "home"

  def index
    ids = current_user.followings_ids.members
    ids.push(current_user.id)
    @activities = Activity.where(user_id: ids, published: true)
    .includes(:trackable, :user, :recipient)
    .order(id: :desc)
    .paginate(:page => params[:page], :per_page => 20)
  end

  def show
    @activity = Activity.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  private

  def find_user
    @user = User.find(params[:user_id])
  end

end
