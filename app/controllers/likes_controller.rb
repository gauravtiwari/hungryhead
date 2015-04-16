class LikesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_votable, only: [:like, :likers]

  after_action :verify_authorized, :only => [:create, :destroy, :update]
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def like
    authorize @votable
    if current_user.voted_for? @votable
      @voter = @votable.class.to_s == "Idea" ? @votable.student : @votable.user
      @like = LikeService.new(current_user, @votable, @owner, profile_url(current_user)).unlike
    else
      @like = LikeService.new(current_user, @votable, @owner, profile_url(current_user)).like
    end
    voted = current_user.voted_for? @votable
    render json: { 
      voted: voted, 
      url: like_path(votable_type: @votable.class.to_s, votable_id: @votable.id), 
      votes_count: @votable.cached_votes_total 
    }
    expire_fragment("activities/activity-#{@votable.class.to_s}-#{@votable.id}-user-#{current_user.id}")
  end

  def likers
    @likers = @votable.votes_for.paginate(:page => params[:page], :per_page => 10)
    render 'likers/index'
  end

  def mentionables
    @mentionable = params[:mentionable_type].constantize.find(params[:id])
    if @mentionable.class.to_s == "Idea"
      mentionable = @mentionable.student
    else 
      mentionable = @mentionable.user
    end
    @mentionables = Array.new
    @comment_users = @mentionables.push(name: mentionable.name, path: user_path(mentionable), username: mentionable.username) unless @mentionables.include?(mentionable.name)
    @mentionable.comment_threads.includes(:user).each do |comment|
      @user = @mentionables.push(name: comment.user.name, path: user_path(comment.user), username: comment.user.username) unless @mentionables.include?(comment.user.name)
    end
    render json: @mentionables
  end

  private

  def load_votable
    @votable = params[:votable_type].safe_constantize.find(params[:votable_id])
  end
end
