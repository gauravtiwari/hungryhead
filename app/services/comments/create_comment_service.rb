class CreateCommentService
  def initialize(params, commentable, user)
    @params = params
    @user = user
    @commentable = commentable
  end

  def call
    comment = @user.comments.new @params
    comment.commentable = @commentable
    comment
  end
end
