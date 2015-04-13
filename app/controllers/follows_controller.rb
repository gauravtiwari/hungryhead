class FollowsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_followable

  def create
    if current_user.follows?(@followable)
      current_user.unfollow(@followable)
      #remove count for following
      current_user.following_count.decrement
      #remove count for followers
      @followable.follower_count.decrement

      #Push followers ids for followable
      @followable.followers_ids.delete(current_user.id)
      @followable.recent_followers.delete({
        :id => current_user.id,
        :first_name => current_user.first_name, 
        :last_name => current_user.last_name, 
        :avatar => current_user.avatar.url(:avatar),
        :url => profile_path(current_user)
      })

      #Push followings id for follower
      current_user.followings_ids.delete(@followable.id)
      current_user.recent_followings.delete({
        :id => @followable.id,
        :first_name => @followable.first_name, 
        :last_name => @followable.last_name, 
        :avatar => @followable.avatar.url(:avatar),
        :url => profile_path(@followable)
      })

      NewUnfollowNotificationJob.perform_later(current_user, @followable)
    else
      current_user.follow(@followable)
      #add count for following to follower
      current_user.following_count.increment
      #add count for followers for followable
      @followable.follower_count.increment

      #Push followers id to followable
      @followable.followers_ids << current_user.id
      @followable.recent_followers << {
        :id => current_user.id,
        :first_name => current_user.first_name, 
        :last_name => current_user.last_name, 
        :avatar => current_user.avatar.url(:avatar),
        :url => profile_path(current_user)
      }

      #Push followings ids to follower
      current_user.followings_ids << @followable.id
      current_user.recent_followings << {
        :id => @followable.id,
        :first_name => @followable.first_name, 
        :last_name => @followable.last_name, 
        :avatar => @followable.avatar.url(:avatar),
        :url => profile_path(@followable)
      }
      NewFollowNotificationJob.perform_later(current_user, @followable)
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
