class FollowsController < ApplicationController

  before_action :authenticate_user!
  before_action :load_followable

  def create
    @follow = CreateFollowService.new(current_user, @followable).create
    if @follow
      render json: { follow: @followable.follower?(current_user), followers_count: @followable.followers_counter.value  }
    end
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
    @follwables = ["Idea", "Student", "School", "Mentor", "Teacher", "User"]
    if @follwables.include? params[:followable_type]
      followable_type = params[:followable_type]
      unless followable_type.safe_constantize.find(params[:followable_id]).blank?
        @followable = followable_type.safe_constantize.find(params[:followable_id])
      else
        raise ActiveRecord::RecordNotFound
      end
    else
      respond_to do |format|
       format.html { render json: {error: 'Sorry, unable to follow this entity'}, status: :unprocessable_entity }
      end
    end
  end

end
