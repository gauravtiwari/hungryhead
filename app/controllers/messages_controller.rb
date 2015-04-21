class MessagesController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, only: [:create]
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def new
    @user = current_user
  end

  def create
    id = params['recipients'] || params['recipient']
    recipients = User.where(id: id)
    authorize @conversation
    conversation = current_user.send_message(recipients, params[:message][:body], params[:message][:subject]).conversation
    flash[:success] = "Message has been sent!"
    redirect_to conversation_path(conversation, box: 'sent')
  end

end