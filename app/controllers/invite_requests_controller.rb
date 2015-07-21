class InviteRequestsController < ApplicationController

  respond_to :json, :html
  layout "home"

  # POST /invite_requests
  # POST /invite_requests.json
  def create
    @invite_request = InviteRequest.new(invite_request_params)
    respond_to do |format|
      if @invite_request.save
        format.js {render :show}
      else
       format.js {render :show}
      end
    end

  end

  private

  def invite_request_params
    params.require(:invite_request).permit(:name, :email, :url, :type)
  end

end
