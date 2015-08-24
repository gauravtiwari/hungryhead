class Vote < ActiveRecord::Base

  #Don't delete straightaway
  acts_as_paranoid

  #Callbacks for storing cache in redis
  before_destroy :update_counters, :delete_cached_voters_ids, :delete_activity
  after_commit :update_counters, :create_activity, :cache_voters_ids, on: :create

  #Model Associations
  belongs_to :voter, -> {with_deleted}, class_name: 'User', foreign_key: 'voter_id'
  belongs_to :votable, -> {with_deleted}, :polymorphic => true, touch: true

  validates_presence_of :votable_id
  validates_presence_of :voter_id

  #Scopes for fetching records
  scope :votes_for, ->(voter, votable) {
    where(
      voter_id: voter.id,
      votable_id: votable.id,
      votable_type: votable.class.to_s
    )
  }

  public

  def votable_user
    votable.user
  end

  private

  #Create activity
  def create_activity
    CreateActivityJob.set(wait: 10.seconds).perform_later(id, self.class.to_s) if Activity.where(trackable: self).empty?
  end

  def update_counters
    #Increment votes counter
    votable.votes_counter.reset
    votable.votes_counter.incr(votable.votes.size)
  end

  def cache_voters_ids
    #Cache voters ids in redis
    votable.voters_ids << voter_id unless votable.voted?(voter)
  end

  def delete_cached_voters_ids
    #Delete cached voters ids in redis
    votable.voters_ids.delete(voter_id) if votable.voted?(voter)
  end

  #Delete notification before destroying vote
  def delete_activity
    #delete notification if record is destroyed
    DeleteActivityJob.set(wait: 10.seconds).perform_later(self.id, self.class.to_s)
  end

end