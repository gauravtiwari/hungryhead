class CommentsController < ApplicationController

  before_action :authenticate_user!
  before_filter :find_comment, only: [:vote, :update]
  before_filter :check_commentables, only: [:index, :create]
  after_action :verify_authorized, :only => [:destroy, :update]
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def index
    @commentable = params[:commentable_type].safe_constantize.find(params[:id])
    @comments = @commentable.root_comments.paginate(:page => params[:page], :per_page => 10)
  end

  def create
    if @commentables.include? params[:comment][:commentable_type]
      @commentable = params[:comment][:commentable_type].safe_constantize.find(params[:comment][:commentable_id])
      @comment = CreateCommentService.new(comment_params, @commentable, current_user).create
      if @comment.save
        Pusher.trigger_async("#{@comment.commentable_type}-#{@comment.commentable_id}-comments",
          "new_comment",
          { data: render(:show)}
        )
       CreateActivityJob.set(wait: 2.seconds).perform_later(@comment.id, @comment.class.to_s)
       expire_fragment("activities/activity-#{@commentable.class.to_s}-#{@commentable.id}-user-#{current_user.id}")
      else
        respond_to do |format|
          format.json { render json: @comment.errors,  status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
       format.json { render json: {error: 'Sorry, unable to comment on this entity'}, status: :unprocessable_entity }
      end
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

  def check_commentables
    @commentables = ["Idea", "Feedback", "Investment", "Note"]
  end

  def find_comment
    @comment = Comment.find(params[:id])
  end

end
