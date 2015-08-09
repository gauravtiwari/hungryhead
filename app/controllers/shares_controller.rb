class SharesController < ApplicationController

  before_filter :authenticate_user!
  before_filter :find_share, only: [:show, :destroy]
  after_action :verify_authorized, :only => [:destroy]
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /shares/new
  def new
    @share = Share.new
    @user = params[user].constantize.find(user_id)
  end

  # GET /shares/1/edit
  def edit
    @user = params[user].constantize.find(user_id)
  end

  def create
    @user = params[user].constantize.find(user_id)
    @share = CreateShareService.new(share_params, user).create
    if @share.save
      render :show, status: :created
    else
      render json: @share.errors, status: :unprocessible_entity
    end
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

  def find_share
    @share = Share.find(params[:id])
  end

end