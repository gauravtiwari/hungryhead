class NotificationsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_user


  def index
    @notifications = Activity.where(user_id: current_user.followings_ids, published: true).map{|activity| activity.user.latest_notifications.revrange(0,100)}
    render json: Oj.dump(@notifications.uniq.flatten, mode: :compat)
  end

  def ideas
    @idea = Idea.find(params[:id])
    @notifications = Activity.where(recipient_id: @idea.id, published: true).map{|activity| @idea.latest_notifications.revrange(0,100)}
    render json: Oj.dump(@notifications.uniq.flatten, mode: :compat)
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
