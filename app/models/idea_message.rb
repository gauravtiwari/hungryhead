class IdeaMessage < ActiveRecord::Base
	
  #Associations
  belongs_to :student
  belongs_to :idea

end
