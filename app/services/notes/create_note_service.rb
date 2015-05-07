class CreateNoteService

  def initialize(params, user)
    @params = params
    @user = user
  end

  def create
    @note = Note.new @params
    @note.user = @user
    @note
  end

end