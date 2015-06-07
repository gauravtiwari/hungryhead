class Mentor < User

  store_accessor :interests, :locations, :hobbies, :markets
  attr_reader :raw_invitation_token
  before_save :add_role

  public

  def mentor?
    true
  end

  def add_role
    self.role = 3
  end

end
