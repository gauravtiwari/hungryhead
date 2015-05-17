class Mentor < User

  store_accessor :interests, :locations, :hobbies, :markets

  public

  def mentor?
    true
  end

end
