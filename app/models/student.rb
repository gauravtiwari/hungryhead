class Student < User
	has_many :ideas, dependent: :destroy, autosave: true
  has_many :idea_messages, dependent: :destroy, autosave: true
	store_accessor :interests, :locations, :subjects, :hobbies, :markets
	store_accessor :education, :year
end
