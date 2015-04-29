class FollowsController < ApplicationController

  before_action :authenticate_user!
  before_action :load_followable

  def create
    if current_user.follows?(@followable)
      @follow = CreateFollowService.new(current_user, @followable).unfollow
      render json: {
        follow: false,
        followers_count: @followable.followers_counter.value
      }
    else
      @follow = CreateFollowService.new(current_user, @followable).follow
      if @follow.save
        render json: {
          follow: true,
          followers_count: @followable.followers_counter.value
        }
      FollowNotificationService.new(@follow).notify unless @followable.class.to_s == "School"
      else
        respond_to do |format|
          format.json {render json: @follow.errors, status: unprocessable_entity}
        end
      end
    end

  end

  def followers
    @followers = @followable.followers
    render 'follows/followers'
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
