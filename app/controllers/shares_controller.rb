class SharesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_share, only: [:show, :destroy, :likers]
  after_action :verify_authorized, :only => [:destroy]
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def create
    @shareable = Idea.find(params[:shareable_id])
    if @shareable.shared?(current_user)
      render json: {error: 'Already shared'}
    else
      @share = CreateShareService.new(share_params, current_user, @shareable).create
      if @share.save
        render :show, status: :created
        CheckUnprocessedMeritActionsJob.set(wait: 2.seconds).perform_later
      else
        render json: @share.errors, status: :unprocessible_entity
      end
    end
  end

  def sharers
    @shareable = Idea.find(params[:shareable_id])
    @sharers = @shareable.shares.paginate(:page => params[:page], :per_page => 10)
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
    params.require(:share).permit(:body, :shareable_id, :shareable_type)
  end

  def find_share
    @share = Share.find(params[:id])
  end

end
