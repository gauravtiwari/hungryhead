class SharesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_share, only: [:show, :destroy]
  before_filter :load_shareable, only: [:create, :sharers]
  after_action :verify_authorized, :only => [:destroy]
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def create
    if @shareable.shared?(current_user)
      render json: {error: 'Already shared'}
    else
      @share = CreateShareService.new(share_params, current_user, @shareable).create
      if @share.save
        render :show, status: :created
      else
        render json: @share.errors, status: :unprocessible_entity
      end
    end
    expire_fragment("activities/activity-#{@share.shareable_type}-#{@share.shareable_id}")
    CreateActivityJob.set(wait: 2.seconds).perform_later(@share.id, @share.class.to_s)
  end

  def sharers
    @sharers = User.find(@shareable.sharers_ids.values).paginate(:page => params[:page], :per_page => 10)
    render :index
  end

  # DELETE /share/1
  # DELETE /share/1.json
  def destroy
    authorize @share
    DestroyRecordJob.perform_later(@share)
    render json: {message: "Share deleted", deleted: true}
  end

  private
  def share_params
    params.require(:share).permit(:body)
  end

  def load_shareable
    @shareables = ["Idea", "Feedback", "Post"]
    if @shareables.include? params[:shareable_type]
      @shareable = params[:shareable_type].safe_constantize.find(params[:shareable_id])
    else
      respond_to do |format|
       format.html { render json: {error: 'Sorry, unable to share this entity'}, status: :unprocessable_entity }
      end
    end
  end

  def find_share
    @share = Share.find(params[:id])
  end

end
