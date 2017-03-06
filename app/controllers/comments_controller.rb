class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: [:create]

  def index
    #  Find commentable and association comments
    @commentable = params[:commentable_type].constantize.find_by_uuid(params[:id])
    @comments = @commentable.root_comments.paginate(page: params[:page], per_page: 10)
  end

  def create
    @comment = CreateCommentService.new(comment_params, @commentable, current_user).call
    if @comment.save
      Pusher.trigger_async("#{@comment.commentable_type}-#{@comment.commentable.uuid}-comments",
                           'new_comment',
                           data: render(:show, locals: { comment: @comment }))
    else
      render json: @comment.errors, notice: "Something went wrong. #{@comment.errors}"
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    authorize @comment
    # destory record and dependencies
    DestroyRecordJob.perform_later(@comment)
    render json: { message: 'Comment deleted', deleted: true }
  end

  private

  def set_commentable
    commentable_type = params[:comment][:commentable_type]
    commentable_id = params[:comment][:commentable_id]

    if %w(Feedback Investment Event).include? commentable_type
      @commentable = commentable_type.safe_constantize.find_by_uuid(commentable_id)
    else
      respond_to do |format|
        flash[:error] = 'Sorry, unable to comment on this entity'
        format.json do
          render json: {
            error: 'Sorry, unable to comment on this entity'
          }, status: :unprocessable_entity
        end
      end
    end
  end

  def comment_params
    params.require(:comment).permit(:id, :parent_id, :body)
  end
end
