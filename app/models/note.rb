class Note < ActiveRecord::Base
  belongs_to :user
  #Includes concerns
  include Commentable
  include Shareable
  include Votable
end
