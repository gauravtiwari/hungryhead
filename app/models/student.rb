class Student < User

  #relations and identity caching
  has_many :ideas, dependent: :destroy, autosave: true
  has_many :idea_messages, dependent: :destroy, autosave: true

  #JSONB postgres store  accessors
  store_accessor :interests, :locations, :hobbies, :markets

  before_create :add_role

  public

  def student?
    true
  end

  def add_role
    self.role = 1
  end

end
