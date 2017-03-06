class IdeaMessagesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_idea, except: [:destroy]
  respond_to :json

  # GET /idea_messages
  # GET /idea_messages.json
  def index
    @idea_messages = @idea.get_idea_messages.paginate(page: params[:page], per_page: 20)
  end

  # POST /idea_messages
  # POST /idea_messages.json
  def create
    @idea_message = IdeaMessage.new(idea_message_params)
    @idea_message.update_attributes(user_id: current_user.id, idea: @idea)
    authorize @idea_message
    if @idea_message.save
      Pusher.trigger("presence-idea-collaboration-#{@idea.slug}", 'collaboration_new_message',
                     { id: @idea_message.id, data: render(template: 'idea_messages/show') }.to_json)
    else
      render json: @idea_message.errors, status: :unprocessable_entity
    end
  end

  # DELETE /idea_messages/1
  # DELETE /idea_messages/1.json
  def destroy
    @idea_message = IdeaMessage.find(params[:id])
    @idea_message.destroy

    respond_to do |format|
      format.html do
        redirect_to idea_messages_url,
                    notice: 'Idea message was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  # Set common parameters between actions
  def set_idea
    @idea = Idea.find(params[:idea_id])
  end

  # White-listed attributes
  def idea_message_params
    params.require(:idea_message).permit(:body)
  end
end
