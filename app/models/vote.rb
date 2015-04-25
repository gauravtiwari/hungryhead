class Vote < ActiveRecord::Base
  #Model Associations
  belongs_to :voter, :polymorphic => true
  belongs_to :votable, :polymorphic => true
  validates_presence_of :votable_id
  validates_presence_of :voter_id

  before_destroy :decrement_counter
  after_create :increment_counter

  private

  def increment_counter
    votable.votes_counter.increment
    votable.voters_ids.add(voter.id, created_at)
  end

  def decrement_counter
    votable.votes_counter.decrement if votable.votes_counter.value > 0
    votable.voters_ids.delete(voter.id)
  end

end
