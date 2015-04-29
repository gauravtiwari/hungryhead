class Vote < ActiveRecord::Base

  #Model Associations
  belongs_to :voter, :polymorphic => true
  counter_culture :voter

  belongs_to :votable, :polymorphic => true
  counter_culture :votable

  validates_presence_of :votable_id
  validates_presence_of :voter_id

  before_destroy :remove_cache_ids, :delete_notification
  after_commit :cache_ids, :update_activity_score, on: :create

  private

  def cache_ids
    votable.voters_ids.push(voter.id)
    votable.score + 1 if votable.can_score?
    voter.score + 1

    save_cache
  end

  def update_activity_score
    @activity = Activity.find_by_recipient_id_and_recipient_type(votable)
    @activity.score = score + 1
    @activity.save
  end

  def remove_cache_ids
    votable.voters_ids.delete(voter.id.to_s)
    votable.score - 1 if votable.can_score?
    voter.score - 1

    save_cache
  end

  def save_cache
    votable.save
    voter.save
  end

  def delete_notification
    DeleteUserNotificationJob.perform_later(self.id, self.class.to_s)
  end

end
