class NotificationsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_user

  def index
    @notifications = @user.latest_notifications.revrange(0, 100)
    .paginate(:page => params[:page], :per_page => 10)
    render json: Oj.dump(@notifications, mode: compat)
  end

  def ideas
    @idea = Idea.find(params[:id])
    @notifications = @idea.latest_notifications.revrange(0, 100)
    .paginate(:page => params[:page], :per_page => 10)
    render json: Oj.dump(@notifications, mode: compat)
  end

  def mark_as_read
    @notification = params[:type].constantize.find(params[:id])
    UpdateNotificationCacheService.new(@user, @notification).update
    @notifications = @idea.latest_notifications.revrange(0, 100)
    .paginate(:page => params[:page], :per_page => 10)
    render json: Oj.dump(@notifications, mode: compat)
  end

  def mark_all_as_read
    UpdateAllActivityJob.perform_later(@user)
    @notifications = @idea.latest_notifications.revrange(0, 100)
    .paginate(:page => params[:page], :per_page => 10)
    render json: Oj.dump(@notifications, mode: compat)
  end

  private

  def set_user
    @user = current_user
  end

end
