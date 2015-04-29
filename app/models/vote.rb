class Vote < ActiveRecord::Base

  #Model Associations
  belongs_to :voter, :polymorphic => true
  counter_culture :voter

  belongs_to :votable, :polymorphic => true
  counter_culture :votable

  validates_presence_of :votable_id
  validates_presence_of :voter_id

  before_destroy :decrement_counter, :delete_notification
  after_create :increment_counter

  private

  def increment_counter
    votable.votes_counter.increment
    votable.voters_ids.add(voter.id, created_at.to_i)
  end

  def decrement_counter
    votable.votes_counter.decrement if votable.votes_counter.value > 0
    votable.voters_ids.delete(voter.id)
  end

  def delete_notification
    DeleteUserNotificationJob.perform_later(self.id, self.class.to_s)
  end

end
