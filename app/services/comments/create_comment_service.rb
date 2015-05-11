class CreateCommentService

  include Wisper::Publisher

  def initialize(params, commentable, user)
    @params = params
    @user = user
    @commentable = commentable
  end

  def call
    comment = @user.comments.new @params
    comment.commentable = @commentable

    if comment.save
      publish :comment_created, comment
    else
      publish :comment_error, comment
    end

  end

end