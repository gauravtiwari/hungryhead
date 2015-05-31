class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_mailbox
  before_action :get_conversation, except: [:index, :recent, :empty_trash]
  before_action :get_box, only: [:index, :show, :recent]

  layout "home"

  def index
    @conversations = @conversations.paginate(page: params[:page], per_page: 10)
  end

  def recent
    @conversations = @mailbox.inbox.order(created_at: :desc).paginate(page: params[:page], per_page: 5)
  end

  def show
    @conversations = @conversations.paginate(page: params[:page], per_page: 10)
    @receipts = @conversation.receipts_for(current_user).order(id: :desc).paginate(page: params[:page], per_page: 10)
    @conversation.mark_as_read(current_user)
  end

  def mark_as_read
    if @conversation.is_unread?(current_user)
      @conversation.mark_as_read(current_user)
    else
      @conversation.mark_as_unread(current_user)
    end
    render json: {unread: @conversation.is_unread?(current_user), id: @conversation.id}
  end

  def reply
    @reply = current_user.reply_to_conversation(@conversation, params[:body])
    render :reply, status: :created
  end

  def destroy
    @conversation.move_to_trash(current_user)
    render json: {deleted: true, id: @conversation.id, message: "Conversation moved to trash"}
  end

  def restore
    @conversation.untrash(current_user)
    render json: {restored: true, id: @conversation.id, message: "Conversation restored to inbox"}
  end

  def empty_trash
    @mailbox.trash.each do |conversation|
      conversation.receipts_for(current_user).update_all(deleted: true)
    end
    flash[:success] = 'Your trash was cleaned!'
    redirect_to conversations_path
  end

  private

  def get_mailbox
    @user = current_user
    @mailbox ||= current_user.mailbox
  end

  def get_conversation
    @conversation ||= @mailbox.conversations.find(params[:id])
  end

  def get_box
    if params[:box].empty? or !["inbox","sent","trash"].include?(params[:box])
      params[:box] = 'inbox'
      if params[:action] == "show"
        redirect_to(conversation_path(@conversation, box: params[:box]))
      elsif params[:action] == "index"
        redirect_to(conversations_path(box: params[:box]))
      end
    end
    @box = params[:box]
    if @box.eql? "inbox"
      @conversations = @mailbox.inbox
    elsif @box.eql? "sent"
      @conversations = @mailbox.sentbox
    else
      @conversations = @mailbox.trash
    end
  end
end