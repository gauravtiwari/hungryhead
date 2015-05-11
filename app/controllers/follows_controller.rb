class FollowsController < ApplicationController

  before_action :authenticate_user!
  after_action :verify_authorized, except: [:index]
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  before_action :load_followable

  def create
    if @followable.followed_by?(current_user)
     unfollow
    else
     follow
    end
  end

  def follow
    @follow = current_user.followings.new(followable: @followable)
    authorize @follow.follower
    if @follow.save
      CreateActivityJob.set(wait: 2.seconds).perform_later(@follow.id, @follow.class.to_s) unless followable_type == "School"
      render json: {
        follow: @followable.followed_by?(current_user),
        followers_count: @followable.followers_counter.value
      }
    else
      respond_to do |format|
        format.json {render json: @follow.errors, status: unprocessable_entity}
      end
    end
  end

  def unfollow
    @follow = current_user.followings.where(followable: @followable).first
    authorize @follow.follower
    if @follow.destroy
      render json: {
        follow: @followable.followed_by?(current_user),
        followers_count: @followable.followers_counter.value
      }
    else
      respond_to do |format|
        format.json {render json: @follow.errors, status: unprocessable_entity}
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
