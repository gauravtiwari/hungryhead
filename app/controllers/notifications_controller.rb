class NotificationsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_user

  def index
    @notifications = @user.ticker.revrange(0, 100)
    .paginate(:page => params[:page], :per_page => 20)
    render json: @notifications
  end

  def friends
    @notifications = @user.friends_notifications.revrange(0, 100)
    .paginate(:page => params[:page], :per_page => 20)
    render json: @notifications
  end

  def mark_as_read
    @notification = params[:type].constantize.find(params[:id])
    UpdateNotificationCacheService.new(@notification).update
    @notifications = @user.ticker.revrange(0, 100)
    .paginate(:page => params[:page], :per_page => 20)
    render json: {count: 0}
  end

  def mark_all_as_read
    UpdateAllActivityJob.perform_later(@user)
    @notifications = @user.ticker.revrange(0, 100)
    .paginate(:page => params[:page], :per_page => 20)
    render json: {count: 0}
  end

  private

  def set_user
    @user = current_user
  end

end
