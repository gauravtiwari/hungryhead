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
    @comment = Comment.new comment_params
    @commentable = params[:comment][:commentable_type].safe_constantize.find(params[:comment][:commentable_id])
    @comment.commentable = @commentable
    @comment.user = current_user
    if @comment.save
      if current_user != @commentable.user
        NewCommentNotificationJob.perform_later(current_user, @comment, @commentable.class.to_s)
      end
      @comment.body.scan(/@\w+/).each do |username|
        user = User.friendly.find_by_username(username.gsub('@', ''))
        if user
          @comment.mention!(user)
        end
      end
      expire_fragment("activities/activity-#{@commentable.class.to_s}-#{@commentable.id}-user-#{current_user.id}")
    end
  end

  def update
    authorize @feedback
    respond_to do |format|
      if @feedback.update(feedback_params)
        format.html { redirect_to @feedback, notice: 'Feedback was successfully updated.' }
        format.json { render :show, status: :ok, location: @feedback }
      else
        format.html { render :edit }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
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
    params.require(:comment).permit(:id, :user_id, :commentable_id, :parent_id, :commentable_type, :body)
  end

  def find_comment
    @comment = Comment.find(params[:id])
  end

end
