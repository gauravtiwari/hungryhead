class SharesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_share, only: [:show, :destroy]
  after_action :verify_authorized, :only => [:destroy]
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def create
    @shareable = params[:shareable_type].constantize.find(params[:shareable_id])
    @share = Share.new share_params
    @share.update_attributes!(user: current_user, parameters: {shareable_name: @shareable.name}, shareable: @shareable, status: 1)
    @activity = @share.create_activity(
    key: 'share.create',
    owner: current_user,
    recipient: @shareable.student
    )
    render :show
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
