class CreateNoteService

  def initialize(params, user)
    @params = params
    @user = user
  end

  def create
    @note = Note.new @params
    @note.update_attributes(user: @user)
    @note
  end

end