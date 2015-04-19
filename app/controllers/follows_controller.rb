class FollowsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :load_followable

  def create
    if current_user.follows?(@followable)
      current_user.unfollow(@followable)
      NewUnfollowNotificationJob.perform_later(current_user, @followable)
    else
      current_user.follow(@followable)
      NewFollowNotificationJob.perform_later(current_user, @followable, profile_path(current_user))
    end
    render json: { follow: current_user.follows?(@followable)  }
  end

  def followers
    @followers = @followable.followers_by_type('User')
    render 'follows/followers'
  end

  def followings
    @followings = @followable.following_by_type('User')
    render 'follows/followings'
  end

  private

  def load_followable
    unless params[:followable_type].safe_constantize.find(params[:followable_id]).blank?
      @followable = params[:followable_type].constantize.find(params[:followable_id])
    else
      raise ActiveRecord::RecordNotFound
    end
  end
end
