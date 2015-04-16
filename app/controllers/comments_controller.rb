class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_filter :find_comment, only: [:vote, :update]
  after_action :verify_authorized, :only => [:destroy, :update]
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def index
    @commentable = params[:commentable_type].safe_constantize.find(params[:id])
    @comments = @commentable.root_comments.paginate(:page => params[:page], :per_page => 10)
  end

  def create
    @commentable = params[:comment][:commentable_type].safe_constantize.find(params[:comment][:commentable_id])
    @comment = CreateCommentService.new(comment_params, @commentable, current_user).create
    if @comment.save
     CommentNotificationService.new(@comment, @commentable, current_user, profile_url(current_user)).notify
     CreateMentionService.new(@comment, @comment.body, profile_url(current_user)).mention
     expire_fragment("activities/activity-#{@commentable.class.to_s}-#{@commentable.id}-user-#{current_user.id}")
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    authorize @comment
    DestroyRecordJob.perform_later(@comment)
    render json: {message: "Comment deleted", deleted: true}
  end

  private

  def comment_params
    params.require(:comment).permit(:id, :user_id, :parent_id, :body)
  end

  def find_comment
    @comment = Comment.find(params[:id])
  end

end
