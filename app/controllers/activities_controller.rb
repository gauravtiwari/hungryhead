class ActivitiesController < ApplicationController

  before_action :authenticate_user!
  before_filter :check_terms

  layout "home"

  def index
    ids = current_user.followings_ids.members
    ids.push(current_user.id)
    @activities = Rails.cache.fetch(ids, expire: 2.hours) do
      Activity.where(user_id: ids, published: true)
      .includes(:trackable, :user, :recipient)
      .order(id: :desc)
      .paginate(:page => params[:page], :per_page => 20)
    end
  end

  def show
    @activity = Rails.cache.fetch(params[:id], expire: 2.hours) do
      Activity.find(params[:id])
    end
    respond_to do |format|
      format.js
    end
  end

end
