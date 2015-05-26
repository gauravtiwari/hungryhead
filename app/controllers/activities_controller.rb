class ActivitiesController < ApplicationController

  before_action :authenticate_user!
  before_filter :check_terms

  layout "home"

  def index
    ids = current_user.followings_ids.members
    ids.push(current_user.id)
    max_updated_at = Activity
    .where(user_id: ids, published: true)
    .maximum(:updated_at).try(:utc).try(:to_s, :number)
    cache_key = "activities/activity-#{max_updated_at}"
    @activities = Rails.cache.fetch(cache_key, expires_in: 2.hours) do
      Activity.where(user_id: ids, published: true)
         .includes(:trackable, :user, :recipient)
         .order(id: :desc)
         .paginate(:page => params[:page], :per_page => 20)
    end
  end

  def show
    @activity = Activity.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

end
