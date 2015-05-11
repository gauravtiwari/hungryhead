class Vote < ActiveRecord::Base

  #Model Associations
  belongs_to :voter, :polymorphic => true
  belongs_to :votable, :polymorphic => true

  validates_presence_of :votable_id
  validates_presence_of :voter_id

  #Callbacks for storing cache in redis
  before_destroy :decrement_counter, :delete_notification
  after_commit :increment_counter, :create_notification, :expire_activity_cache, on: :create

  private

  def rebuild_cache
    #rebuild counters and cached_ids for votable
    UpdateVoteCacheJob.perform_later(votable_id, votable_type)
  end

  def increment_counter
    #Increment votes counter
    votable.votes_counter.increment
    #Increment score for voter and idea
    Idea.popular.increment(votable_id) if votable_type == "Idea"
    User.popular.increment(voter_id)
    #Add voter_id to cache
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

  #Expire activity cache after commit
  def expire_activity_cache
    expire_fragment("activities/activity-#{votable_type}-#{votable_id}-user-#{voter.id}")
  end

  #Rollback counters for votable
  def decrement_counter
    #Decrement score for votable and decrement votes counter
    votable.votes_counter.decrement if votable.votes_counter.value > 0
    Idea.popular.decrement(votable_id) if votable_type == "Idea"
    #Decrement popularity score for user
    User.popular.decrement(voter_id)
    #Remove voter_id from votable cache
    votable.voters_ids.delete(voter_id)
  end

  #Delete notification before destroying vote
  def delete_notification
    #delete notification if record is destroyed
    DeleteUserNotificationJob.set(wait: 5.seconds).perform_later(self.id, self.class.to_s)
  end

end
