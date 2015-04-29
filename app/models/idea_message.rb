class IdeaMessage < ActiveRecord::Base
  #Associations
  belongs_to :student, touch: true
  counter_culture :student
  belongs_to :idea
  counter_culture :idea
end
