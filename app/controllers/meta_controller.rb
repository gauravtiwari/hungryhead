class MetaController < ApplicationController
  before_action :set_meta, only: [:show, :comments, :followers, :edit, :update]
  before_action :set_user

  after_action :verify_authorized, only: [:edit, :update]
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  
  layout "meta"

  respond_to :json, :html

  # GET /meta/1
  # GET /meta/1.json
  def show
  end

  # GET /meta/1/comments
  def comments
    @comments = @meta.comment_threads.paginate(:page => params[:page], :per_page => 10)
  end

  # GET /meta/1/followers
  def followers
    @followers = @meta.followers(User).paginate(:page => params[:page], :per_page => 10)
    render 'followers/index'
  end

  # GET /meta/new
  def new
    @meta = Meta.new
    authorize @meta
  end

  # POST /meta
  # POST /meta.json
  def create
    @meta = Meta.new(meta_params)
    respond_to do |format|
      @meta.update_attributes(founders: [@user.id],  user_id: @user.id)
      authorize @meta
      if @meta.save
          format.html { redirect_to @meta, notice: 'Meta was successfully created.' }
          format.json { render :show, status: :created, location: @meta }
      else
        format.html { render :new }
        format.json { render json: @meta.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /meta/1
  # PATCH/PUT /meta/1.json
  def update
      authorize @meta
      if @meta.update(meta_params)
        render :show
      else
        render json: @meta.errors, status: :unprocessable_entity
      end
  end


  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = current_user
  end

  def set_meta
    @meta = Meta.find('meta')
    authorize @meta
  end

  # WhiteListed Params
  def meta_params
    params.require(:meta).permit(:looking_for_team, :cover_position, :video, :logo, :name, :high_concept_pitch,
      :elevator_pitch, :website, :location_list, :description, :cover, :market_list, :market,
       :problems, :technology_list, :solutions, :vision, :value_proposition)
  end

end
