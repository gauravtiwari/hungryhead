class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  layout "idea"

  # GET /posts
  # GET /posts.json
  def index
    @user = User.find(params[:user_id])
    @posts = @user.posts.paginate(:page => params[:page], :per_page => 20)
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @user = User.find(params[:user_id])
    authorize @post
    if @post
      @comments = @post.comment_threads.paginate(:page => params[:page], :per_page => 20)
    end
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = CreatePostService.new(post_params, current_user).create
    authorize @post
    if @post.save
      render json: { created: true, status: :created}
    else
      render json: @post.errors, status: :unprocessable_entity
    end
    CreateActivityJob.set(wait: 2.seconds).perform_later(@post.id, @post.class.to_s)
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    authorize @post
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    authorize @post
    @post.idea.posters.delete(@post.user.id.to_s)
    @post.idea.save!
    DestroyRecordJob.perform_later(@post)
    render json: {message: "Post deleted", deleted: true}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find_by_uuid(params[:id])
      @user = User.find(params[:user_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:id, :body, :title, :status)
    end
end
