class Vote < ActiveRecord::Base
  #Model Associations
  belongs_to :voter, :polymorphic => true
  belongs_to :votable, :polymorphic => true
  validates_presence_of :votable_id
  validates_presence_of :voter_id
end
