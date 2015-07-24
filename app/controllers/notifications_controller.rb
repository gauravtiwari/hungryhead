class NotificationsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_user

  def index
    @notifications = Activity.find(@user.ticker.revrange(0, 100)).map{|activity| activity.json_blob }
    .paginate(:page => params[:page], :per_page => 20)
    render json: @notifications, status: :ok
  end

  def ideas
    @idea = Idea.find(params[:id])
    @notifications = @idea.ticker.revrange(0, 100)
    .paginate(:page => params[:page], :per_page => 10)
    render json: @notifications
  end

  def friends
    @notifications = @user.friends_notifications.revrange(0, 100)
    .paginate(:page => params[:page], :per_page => 20)
    render json: @notifications, status: :ok
  end

  def mark_all_as_read
    UpdateAllActivityJob.perform_later(@user)
    current_user.notifications_counter.clear
    render json: {count: 0, status: :ok}
  end

  private

  def set_user
    @user = current_user
  end

end
