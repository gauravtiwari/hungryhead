class FollowsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_followable

  def follow
    return render_data if @followable.followed_by?(current_user)
    @follow = current_user.followings.new(followable: @followable)
    authorize @follow
    if @follow.save
      render_data
    else
      respond_to do |format|
        format.json { render json: @follow.errors, status: unprocessable_entity }
      end
    end
  end

  def unfollow
    return render_data unless @followable.followed_by?(current_user)
    @follow = current_user.followings.where(followable: @followable).first
    authorize @follow.follower
    if @follow.destroy
      render_data
    else
      respond_to do |format|
        format.json { render json: @follow.errors, status: unprocessable_entity }
      end
    end
  end

  def followers
    @followers = @followable.get_followers.paginate(page: params[:page], per_page: 9)
    render 'follows/followers'
  end

  def followings
    @followings = @followable.get_followings.paginate(page: params[:page], per_page: 9)
    render 'follows/followings'
  end

  private

  def render_data
    render json: Oj.dump(follow: @followable.followed_by?(current_user),
                         followers_count: @followable.followers_counter.value,
                         follower: current_user.card_json)
  end

  def load_followable
    @followables = %w(Idea School User)
    if @followables.include? params[:followable_type]
      followable_type = params[:followable_type]
      if followable_type.safe_constantize.find(params[:followable_id]).blank?
        raise ActiveRecord::RecordNotFound
      else
        @followable = followable_type.safe_constantize.find(params[:followable_id])
      end
    else
      respond_to do |format|
        format.html do
          render json: { error: 'Sorry, unable to follow this entity' },
                 status: :unprocessable_entity
        end
      end
    end
  end
end
