class LikesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_votable, only: [:like, :likers]

  after_action :verify_authorized, :only => [:create, :destroy, :update]
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def like
    if current_user.voted_for? @votable
      authorize @votable.user
      @votable.unliked_by current_user
      UnlikeNotificationJob.perform_later(@votable)
      render json: { voted: false, url: like_path(votable_type: @votable.class.to_s, votable_id: @votable.id), votes_count: @votable.cached_votes_total }
    else
      if @votable.class.to_s == "Idea"
        voter = @votable.student
      else 
        voter = @votable.user
      end
      
      authorize voter
      
      @votable.liked_by current_user
      if current_user != voter
        NewNotificationJob.perform_later(current_user, @votable, "#{@votable.class.to_s.downcase}")
      end
      render json: { voted: true, url: like_path(votable_type: @votable.class.to_s, votable_id: @votable.id), votes_count: @votable.cached_votes_total }
    end
    expire_fragment("activities/activity-#{@votable.class.to_s}-#{@votable.id}-user-#{current_user.id}")
  end

  def likers
    @likers = @votable.votes_for.paginate(:page => params[:page], :per_page => 10)
    render 'likers/index'
  end

  def mentionables
    @mentionable = params[:mentionable_type].constantize.find(params[:id])
    @mentionables = Array.new
    @comment_users = @mentionables.push(name: @mentionable.student.name, path: user_path(@mentionable.student), username: @mentionable.student.username) unless @mentionables.include?(@mentionable.student.name)
    @mentionable.comment_threads.includes(:user).each do |comment|
      @user = @mentionables.push(name: comment.user.name, path: user_path(comment.user), username: comment.user.username) unless @mentionables.include?(comment.user.name)
    end
    render json: @mentionables
  end

  private

  def load_votable
    @votable = params[:votable_type].safe_constantize.find(params[:votable_id])
  end

  def load_socializable
    @socializable =
    case
    when organization_id = params[:organization_id]
      Institution.find(organization_id)
    when idea_id = params[:idea_id]
      Idea.find_by_id(idea_id)
    when user_id = params[:user_id]
      User.find(user_id)
    else
      raise ArgumentError, "Unsupported socializable model, params: " +
        params.keys.inspect
    end
    raise ActiveRecord::RecordNotFound unless @socializable
  end
end
