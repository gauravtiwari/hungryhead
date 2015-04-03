class NotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_note, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized, :only => [:create, :destroy, :update]
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  
  layout "idea"

  respond_to :json, :html

  # GET /notes
  # GET /notes.json
  def index
    @idea = Idea.friendly.find(params[:idea_id])
    authorize @idea
    @notes = @idea.notes
    .order(:id)
    .paginate(:page => params[:page], :per_page => 20)
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes
  # POST /notes.json
  def create
    @idea = Idea.friendly.find(params[:idea_id])
    @note = Note.new note_params
    @note.notable = @idea
    @note.user = current_user
    authorize @note
    respond_to do |format|
      if @note.save
        format.json { render :show, status: :created}
      else
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notes/1
  # PATCH/PUT /notes/1.json
  def update
    authorize @note
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to @note, notice: 'Note was successfully updated.' }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.json
  def destroy
    authorize @note
    DestroyRecordJob.perform_later(@note)
    render json: {message: "Note deleted", deleted: true}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @idea = Idea.friendly.find(params[:idea_id])
      @note = Note.find(params[:id])
      @user = current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def note_params
      params.require(:note).permit(:id, :status, :body)
    end
end
