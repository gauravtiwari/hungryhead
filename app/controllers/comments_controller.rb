
class CommentsController < ApplicationController

  before_action :authenticate_user!
  before_action :check_commentables, only: [:create_comment_service]

  #Add pundit authorization to delete comment
  after_action :verify_authorized, :only => [:destroy]
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def index
    @commentable = params[:commentable_type].safe_constantize.find_by_uuid(params[:id])
    @comments = @commentable.root_comments.paginate(:page => params[:page], :per_page => 10)
  end

  def create
    # If comment created publish via pusher
    create_comment_service.on :comment_created do |comment|
      @comment = comment
      Pusher.trigger_async("#{comment.commentable_type}-#{comment.commentable.uuid}-comments",
        "new_comment",
        { data: render(:show, locals: {comment: comment} )}
      )
      # Enque activity creation
      CreateActivityJob.perform_later(comment.id, comment.class.to_s)
    end

    #If error render errors
    create_comment_service.on :comment_error do |comment|
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


  private

  def create_comment_service
    commentable_type = params[:comment][:commentable_type]
    commentable_id = params[:comment][:commentable_id]

    if ["Idea", "Feedback", "Investment"].include? commentable_type
      @commentable = commentable_type.safe_constantize.find_by_uuid(commentable_id)
      @create_comment_service ||= CreateCommentService.new(comment_params, @commentable, current_user)
    else
      respond_to do |format|
       format.json { render json: {
        error: 'Sorry, unable to comment on this entity'
        }, status: :unprocessable_entity }
      end
    end
  end

  def comment_params
    params.require(:comment).permit(:id, :parent_id, :body)
  end

end
