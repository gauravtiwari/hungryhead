class Student < User
	has_many :ideas, dependent: :destroy, autosave: true
  cache_has_many :ideas, embed: true
  has_many :idea_messages, dependent: :destroy, autosave: true
  cache_has_many :idea_messages, embed: true
	store_accessor :interests, :locations, :hobbies, :markets
	store_accessor :education, :year, :subjects

  def student?
    true
  end

end
