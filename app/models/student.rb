class Student < User
	store_accessor :interests, :locations, :hobbies, :markets
	store_accessor :education, :year
end
