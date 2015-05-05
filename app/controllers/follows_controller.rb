class FollowsController < ApplicationController

  before_action :authenticate_user!
  after_action :verify_authorized, except: [:index]
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  before_action :load_followable

  def create
    if current_user.follows?(@followable)
      @follow = CreateFollowService.new(current_user, @followable).unfollow
      authorize @follow.follower
      render json: {
        follow: current_user.follows?(@followable),
        followers_count: @followable.followers_counter.value
      }
    else
      @follow = CreateFollowService.new(current_user, @followable).follow
      authorize @follow.follower
      if @follow.save
        render json: {
          follow: current_user.follows?(@followable),
          followers_count: @followable.followers_counter.value
        }
      CreateActivityJob.set(wait: 2.seconds).perform_later(@follow.id, @follow.class.to_s)
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
