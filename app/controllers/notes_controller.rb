class NotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_note, only: [:show, :edit, :update, :destroy]
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  layout "idea"

  # GET /notes
  # GET /notes.json
  def index
    @user = User.find(params[:user_id])
    @notes = @user.notes.paginate(:page => params[:page], :per_page => 20)
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
    @user = User.find(params[:user_id])
    authorize @note
    if @note
      @comments = @note.comment_threads.paginate(:page => params[:page], :per_page => 20)
    end
  end

  # POST /notes
  # POST /notes.json
  def create
    @note = CreateNoteService.new(note_params, current_user).create
    authorize @note
    if @note.save
      CreateActivityJob.set(wait: 2.seconds).perform_later(@note.id, @note.class.to_s)
      render json: { created: true, status: :created}
    else
      render json: @note.errors, status: :unprocessable_entity
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
    @note.idea.noteers.delete(@note.user.id.to_s)
    @note.idea.save!
    DestroyRecordJob.perform_later(@note)
    render json: {message: "Note deleted", deleted: true}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
      @user = User.find(params[:user_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def note_params
      params.require(:note).permit(:id, :body, :title, :status)
    end
end
