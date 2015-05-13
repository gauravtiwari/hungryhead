class NotificationsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_user

  def index
    @notifications = @user.friends_notifications.revrange(0, 100)
    .paginate(:page => params[:page], :per_page => 10)
    render json: @notifications
  end

  def ideas
    @idea = Idea.find(params[:id])
    @notifications = @idea.public_notifications.revrange(0, 100)
    .paginate(:page => params[:page], :per_page => 10)
    render json: @notifications
  end

  def mark_as_read
    @notification = params[:type].constantize.find(params[:id])
    UpdateNotificationCacheService.new(@user, @notification).update
    @notifications = @user.friends_notifications.revrange(0, 100)
    .paginate(:page => params[:page], :per_page => 10)
    render json: @notifications
  end

  def mark_all_as_read
    UpdateAllActivityJob.perform_later(@user)
    @notifications = @user.friends_notifications.revrange(0, 100)
    .paginate(:page => params[:page], :per_page => 10)
    render json: @notifications
  end

  private

  def set_user
    @user = current_user
  end

end
