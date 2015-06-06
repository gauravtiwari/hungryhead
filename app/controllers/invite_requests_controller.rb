class InviteRequestsController < ApplicationController

  respond_to :json, :html
  layout "home"

  # POST /invite_requests
  # POST /invite_requests.json
  def create
    @invite_request = InviteRequest.new(invite_request_params)

    if @invite_request.save
     flash[:success] = "Thank you #{@invite_request.name} for submitting your request. We will be in touch."
     render json: {
      created: true,
      status: :created
    }
    else
     render json: @invite_request.errors, status: :unprocessable_entity, created: false
    end

  end

  private

  def invite_request_params
    params.require(:invite_request).permit(:name, :email, :url)
  end

end
