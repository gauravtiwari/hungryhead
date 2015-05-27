class ActivitiesController < ApplicationController

  before_action :authenticate_user!
  before_filter :check_terms

  layout "home"

  def index
    ids = current_user.followings_ids.members
    ids.push(current_user.id)
    activities_ids = Activity.where(user_id: ids, published: true).order(id: :desc).pluck(:id)
    activities = BulkCacheFetcher.new(Rails.cache).fetch(activities_ids) do |activities_ids|
      Activity.includes([:trackable, :user, :recipient])
      .find(activities_ids)
    end
    @activities = activities.paginate(:page => params[:page], :per_page => 20)
  end

  def show
    @activity = BulkCacheFetcher.new(Rails.cache).fetch(params[:id], expire: 2.hours) do
      Activity.includes([:trackable, :user, :recipient]).find(params[:id])
    end
    respond_to do |format|
      format.js
    end
  end

end
