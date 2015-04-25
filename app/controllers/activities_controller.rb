class ActivitiesController < ApplicationController
  before_action :authenticate_user!

  def index
    ids = current_user.followings_ids.members
    ids.push(current_user.id)
    @activities = Activity.where(owner_id: ids, published: true)
    .where.not(key: 'follow.create')
    .order(id: :desc)
    .paginate(:page => params[:page], :per_page => 20)
    respond_to do |format|
      format.html
      format.js
    end
  end

end
