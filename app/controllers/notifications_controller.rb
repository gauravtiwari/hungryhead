class NotificationsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_user

  def index
    @notifications = current_user.latest_notifications.revrange(0, 100)
    .paginate(:page => params[:page], :per_page => 10)
    render json: @notifications
  end

  def ideas
    @idea = Idea.find(params[:id])
    @notifications = @idea.latest_notifications.revrange(0, 100)
    .paginate(:page => params[:page], :per_page => 10)
    render json: @notifications
  end

  def mark_as_read
    @notifications = @user.notifications.order(created_at: :desc).paginate(:page => params[:page], :per_page => 10)
    @user.notifications.where("parameters ->> 'read' = 'false'").find_each do |notification|
      notification.read = true
      notification.save
    end
    render :index
  end

  private

  def set_user
    @user = current_user
  end

end
