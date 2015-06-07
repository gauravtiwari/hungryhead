class Teacher < User

  store_accessor :interests, :locations, :hobbies, :markets

  before_save :add_role

  public

  def teacher?
    true
  end

  def add_role
    self.role = 4
  end

end
