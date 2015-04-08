class IdeaMessage < ActiveRecord::Base
	
  #Associations
  belongs_to :student, touch: true
  belongs_to :idea, counter_cache: true
  
end
