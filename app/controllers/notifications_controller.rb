class NotificationsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_user

  def index
  end

  def ideas
    @idea = Idea.find(params[:id])
    @notifications = @idea.ticker.revrange(0, 100)
    .paginate(:page => params[:page], :per_page => 10)
    render json: @notifications
  end

  def friends
    @notifications = Activity
    .where(id: @user.friends_notifications.revrange(0, 100))
    .order_as_specified(id: @user.friends_notifications.revrange(0, 100))
    .map{|notification| notification.json_blob.merge(created_at: notification.created_at) }
    .paginate(:page => params[:page], :per_page => 20)
    render json: @notifications, status: :ok
  end

  def mark_all_as_read
    current_user.notifications_counter.clear
    render json: {count: 0, status: :ok}
  end

  private

  def set_user
    @user = current_user
  end

end
