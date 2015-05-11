class CommentsController < ApplicationController

  before_action :authenticate_user!
  before_action :check_commentables, only: [:create_comment_service]

  #Add pundit authorization to delete comment
  after_action :verify_authorized, :only => [:destroy]
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def index
    @commentable = params[:commentable_type].safe_constantize.find(params[:id])
    @comments = @commentable.root_comments.paginate(:page => params[:page], :per_page => 10)
  end

  def create
    #If comment created publish via pusher
    create_comment_service.on :success do |comment|
      Pusher.trigger_async("#{comment.commentable_type}-#{comment.commentable_id}-comments",
        "new_comment",
        { data: render(:show)}
      )
    end
    #Subscribe to create activity
    create_comment_service.subscribe( CreateActivityJob.new,
                                on: :create_activity, async: true )

    #If error render errors
    create_comment_service.on :error do |comment|
      respond_to do |format|
        format.json { render json: comment.errors,  status: :unprocessable_entity }
      end
    end

    #Call the comment creation service
    create_comment_service.call
  end

  def destroy
    @comment = Comment.find(params[:id])
    authorize @comment
    DestroyRecordJob.perform_later(@comment)
    render json: {message: "Comment deleted", deleted: true}
  end

  protected

  def create_comment_service
    @create_comment_service ||= CreateCommentService.new(comment_params, @commentable, current_user)
  end

  private

  def comment_params
    params.require(:comment).permit(:id, :user_id, :parent_id, :body)
  end

  def check_commentables
    commentable_type = params[:comment][:commentable_type]
    commentable_id = params[:comment][:commentable_id]
    @commentables = ["Idea", "Feedback", "Investment", "Note", "Share"]
    if @commentables.include? params[:comment][:commentable_type]
      @commentable = commentable_type.safe_constantize.find(commentable_id)
    else
      respond_to do |format|
       format.json { render json: {
        error: 'Sorry, unable to comment on this entity'
        }, status: :unprocessable_entity }
      end
    end
  end

end
