class IdeaMessagesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_idea, except: [:destroy]

  #Verify User Access
  after_action :verify_authorized, :only => [:create, :update, :delete]
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  respond_to :json

  # GET /idea_messages
  # GET /idea_messages.json
  def index
    @idea_messages = IdeaMessage.where(idea_id: @idea.id)
    .order(created_at: :desc)
    .paginate(:page => params[:page], :per_page => 20)
  end

  # POST /idea_messages
  # POST /idea_messages.json
  def create
    @idea_message = IdeaMessage.new(idea_message_params)
    @idea_message.update_attributes(student_id: current_user.id, idea: @idea)
    authorize @idea_message
    if @idea_message.save
      Pusher.trigger("presence-idea-collaboration-#{@idea.team_ids.join('')}", "collaboration_new_message", {id: @idea_message.id, data: render(template: 'idea_messages/show')}.to_json)
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
      format.html { redirect_to idea_messages_url, notice: 'Idea message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  #Set common parameters between actions
  def set_idea
    @idea = Idea.friendly.find(params[:idea_id])
  end

  #White-listed attributes
  def idea_message_params
    params.require(:idea_message).permit(:body)
  end
end
