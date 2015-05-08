class Vote < ActiveRecord::Base

  #Model Associations
  belongs_to :voter, :polymorphic => true
  belongs_to :votable, :polymorphic => true


  validates_presence_of :votable_id
  validates_presence_of :voter_id

  before_destroy :decrement_counter, :delete_notification
  after_create :increment_counter


  private

  def rebuild_cache
    UpdateVoteCacheJob.perform_later(votable_id, votable_type)
  end

  def increment_counter
    votable.votes_counter.increment
    Idea.popular.increment(votable_id) if votable_type == "Idea"
    User.popular.increment(voter_id)
    votable.voters_ids << voter_id
  end

  def decrement_counter
    votable.votes_counter.decrement if votable.votes_counter.value > 0
    Idea.popular.decrement(votable_id) if votable_type == "Idea"
    User.popular.increment(voter_id)
    votable.voters_ids.delete(voter_id)
  end

  def delete_notification
    DeleteUserNotificationJob.perform_later(self.id, self.class.to_s)
  end

end
