class CreatePostService

  def initialize(params, user)
    @params = params
    @user = user
  end

  def create
    @post = Post.new @params
    @post.user = @user
    @post
  end

end