class NotificationsController < ApplicationController
  before_action :authenticate_user!, :set_user

  def index
    @notifications = @user.ticker.revrange(0, 100)
                          .paginate(page: params[:page], per_page: 20)

    # render JSON
    render json: @notifications
  end

  def ideas
    @idea = Idea.find(params[:id])
    @notifications = @idea.ticker.revrange(0, 100)
                          .paginate(page: params[:page], per_page: 20)

    # render JSON
    render json: @notifications
  end

  def friends
    @notifications = @user.friends_notifications
                          .revrange(0, 100).paginate(page: params[:page], per_page: 20)

    # render JSON
    render json: @notifications, status: :ok
  end

  def mark_all_as_read
    current_user.notifications_counter.clear
    render json: { count: 0, status: :ok }
  end

  private

  def set_user
    @user = current_user
  end
end
