class MessagesController < ApplicationController
  before_action :authenticate_user!

  layout "home"

  def new
    @user = current_user
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    id = params['recipients'] || params['recipient']
    recipients = User.where(id: id)
    conversation = current_user.send_message(recipients, params[:message][:body], params[:message][:subject]).conversation
    flash[:success] = "Message has been sent!"
    redirect_to conversation_path(conversation, box: 'sent')
  end

end