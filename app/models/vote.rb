class Vote < ActiveRecord::Base

  #Model Associations
  belongs_to :voter, :polymorphic => true
  belongs_to :votable, :polymorphic => true

  validates_presence_of :votable_id
  validates_presence_of :voter_id

  #Callbacks for storing cache in redis
  before_destroy :decrement_counter, :delete_notification
  after_create :increment_counter

  private

  def rebuild_cache
    #rebuild counters and cached_ids for votable
    UpdateVoteCacheJob.perform_later(votable_id, votable_type)
  end

  def increment_counter
    #Increment votes counter
    votable.votes_counter.increment
    #Increment score for voter and idea
    Idea.popular.increment(votable.idea_json) if votable_type == "Idea"
    User.popular.increment(voter.user_json)
    #Add voter_id to cache
    votable.voters_ids << voter_id
  end

  def decrement_counter
    #Decrement score for votable and decrement votes counter
    votable.votes_counter.decrement if votable.votes_counter.value > 0
    Idea.popular.decrement(votable.idea_json) if votable_type == "Idea"
    #Decrement popularity score for user
    User.popular.decrement(voter.user_json)
    #Remove voter_id from votable cache
    votable.voters_ids.delete(voter_id)
  end

  def delete_notification
    #delete notification if record is destroyed
    DeleteUserNotificationJob.perform_later(self.id, self.class.to_s)
  end

end
