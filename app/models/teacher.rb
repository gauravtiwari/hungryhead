class Teacher < User
	store_accessor :interests, :locations, :hobbies, :markets

  def teacher?
    true
  end

end
