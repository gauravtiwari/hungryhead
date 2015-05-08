class Mentor < User
	store_accessor :interests, :locations, :hobbies, :markets

  def mentor?
    true
  end

end
