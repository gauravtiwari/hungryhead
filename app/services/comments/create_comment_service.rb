class CreateCommentService

  include Wisper::Publisher

  def initialize(params, commentable, user)
    @params = params
    @user = user
    @commentable = commentable
  end

  def call
    comment = Comment.new @params
    comment.commentable = @commentable
    comment.user = @user
    if comment.save
      publish :success, comment
      publish :create_activity, @comment.id, @comment.class.to_s
    else
      publish :error, comment
    end
  end

end