class Vote < ActiveRecord::Base
  before_destroy :update_counters, :delete_cached_voters_ids, :delete_activity
  after_commit :update_counters, :create_activity, :cache_voters_ids, on: :create

  belongs_to :voter, class_name: 'User', foreign_key: 'voter_id'
  belongs_to :votable, polymorphic: true, touch: true

  validates_presence_of :votable_id
  validates_presence_of :voter_id

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

  def create_activity
    if Activity.where(trackable: self).empty?
      CreateActivityJob.set(
        wait: 10.seconds
      ).perform_later(id, self.class.to_s)
    end
  end

  def update_counters
    votable.votes_counter.reset
    votable.votes_counter.incr(votable.votes.size)
    true
  end

  def cache_voters_ids
    votable.voters_ids << voter_id unless votable.voted?(voter)
  end

  def delete_cached_voters_ids
    votable.voters_ids.delete(voter_id) if votable.voted?(voter)
    true
  end

  def delete_activity
    Activity.where(
      trackable_id: id,
      trackable_type: self.class.to_s
    ).each do |activity|
      DeleteNotificationCacheService.new(activity).delete
      activity.destroy if activity.present?
    end
  end
end
