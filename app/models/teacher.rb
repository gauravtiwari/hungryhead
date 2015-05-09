class Teacher < User
	store_accessor :interests, :locations, :hobbies, :markets

  public

  def teacher?
    true
  end
end
