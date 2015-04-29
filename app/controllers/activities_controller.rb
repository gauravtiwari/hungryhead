class ActivitiesController < ApplicationController
  before_action :authenticate_user!
  before_filter :check_terms

  layout "home"

  def index
    ids = current_user.followings_ids
    ids.push(current_user.id)
    @activities = Activity.where(user_id: ids, published: true)
    .order(id: :desc)
    .paginate(:page => params[:page], :per_page => 20)
  end

end
