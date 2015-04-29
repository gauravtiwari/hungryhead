class NotificationsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_user


  def index
    @notifications = Notification.where(user_id: current_user.followings_ids, published: true).order(created_at: :desc).paginate(:page => params[:page], :per_page => 10)
  end

  def ideas
    @idea = Idea.find(params[:id])
    @notifications = Notification.where(recipient_id: @idea.id, published: true).order(created_at: :desc).paginate(:page => params[:page], :per_page => 20)
    render :index
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
