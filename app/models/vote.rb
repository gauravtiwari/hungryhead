class Vote < ActiveRecord::Base

  #Model Associations
  belongs_to :voter, :polymorphic => true
  belongs_to :votable, :polymorphic => true

  validates_presence_of :votable_id
  validates_presence_of :voter_id

  #Callbacks for storing cache in redis
  before_destroy :decrement_counter, :delete_notification
  after_commit :increment_counter, :create_notification, on: :create

  private

  def rebuild_cache
    #rebuild counters and cached_ids for votable
    UpdateVoteCacheJob.perform_later(votable_id, votable_type)
  end

  def increment_counter
    #Increment votes counter
    votable.votes_counter.increment
    votable.voters_ids << voter_id
  end

  def award_badge
    user_id = votable_type == "Idea" ? votable.student.id : votable.user.id
    AwardBadgeJob.set(wait: 5.seconds).perform_later(user_id, 3, "#{votable_type}_#{votable_id}") if votable.most_voted?
  end

  #Enque notification after commit
  def create_notification
    CreateActivityJob.set(wait: 2.seconds).perform_later(self.id, self.class.to_s)
  end

  #Rollback counters for votable
  def decrement_counter
    #Decrement score for votable and decrement votes counter
    votable.votes_counter.decrement if votable.votes_counter.value > 0
    votable.voters_ids.delete(voter_id)
  end

  #Delete notification before destroying vote
  def delete_notification
    #delete notification if record is destroyed
    DeleteUserNotificationJob.set(wait: 5.seconds).perform_later(self.id, self.class.to_s)
  end

end
