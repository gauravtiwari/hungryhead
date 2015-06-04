class Mentor < User

  store_accessor :interests, :locations, :hobbies, :markets
  attr_reader :raw_invitation_token

  public

  def mentor?
    true
  end

end
