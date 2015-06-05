class InviteRequestsController < ApplicationController

  respond_to :json, :html
  layout "home"

  # POST /invite_requests
  # POST /invite_requests.json
  def create
    @invite_request = InviteRequest.new(invite_request_params)

    if @invite_request.save
     flash[:success] = "Thank you, we have received your invite request and we will be in touch soon."
     render json: {
      created: true,
      status: :created
    }
    else
     flash[:error] = "Something went wrong"
     render json: @invite_request.errors, status: :unprocessable_entity, created: false
    end

  end

  private

  def invite_request_params
    params.require(:invite_request).permit(:name, :email, :url)
  end

end
