class CreateCommentService

  def initialize(params, commentable, user)
    @params = params
    @user = user
    @commentable = commentable
  end

  def create
    @comment = Comment.new @params
    @comment.commentable = @commentable
    @comment.user = @user
    @comment
  end

end