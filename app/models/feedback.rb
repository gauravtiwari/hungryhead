class Feedback < ActiveRecord::Base
  include Redis::Objects
  before_destroy :update_counters, :delete_feedbacker_ids, :delete_activity
  after_commit :update_counters, :cache_feedbacker_ids, :create_activity, on: :create

  has_merit

  counter :votes_counter
  counter :comments_counter
  counter :views_counter
  counter :shares_counter

  list :voters_ids
  list :commenters_ids

  sorted_set :leaderboard, global: true
  sorted_set :trending, global: true

  include Commentable
  include Votable

  belongs_to :idea, touch: true
  belongs_to :user, touch: true

  acts_as_taggable_on :categories

  enum status: { posted: 0, badged: 1, flagged: 2 }
  enum badge: { initial: 0, helpful: 1, unhelpful: 2, irrelevant: 3 }

  def idea_owner
    idea.user
  end

  private

  def update_counters
    user.feedbacks_counter.reset
    user.feedbacks_counter.incr(user.feedbacks.size)
    idea.feedbackers_counter.reset
    idea.feedbackers_counter.incr(idea.feedbacks.size)
  end

  def cache_feedbacker_ids
    idea.feedbackers_ids << user_id unless idea.feedbacked?(user)
    Feedback.leaderboard.add(id, points)
  end

  def delete_feedbacker_ids
    idea.feedbackers_ids.delete(user_id) if idea.feedbacked?(user)
    Feedback.leaderboard.delete(id)
  end

  def create_activity
    if Activity.where(trackable: self).empty?
      CreateActivityJob.set(
        wait: 10.seconds
      ).perform_later(id, self.class.to_s)
    end
  end

  def delete_activity
    Activity.where(trackable_id: id, trackable_type: self.class.to_s).each do |activity|
      DeleteNotificationCacheService.new(activity).delete
      activity.destroy if activity.present?
    end
  end
end
