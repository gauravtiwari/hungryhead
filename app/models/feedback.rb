class Feedback < ActiveRecord::Base

  include Redis::Objects

  #Don't delete straightaway
  acts_as_paranoid

  #Hooks
  before_destroy :update_counters, :delete_feedbacker_ids, :delete_activity
  after_commit :update_counters, :cache_feedbacker_ids, :create_activity, on: :create

  #Gamification for feedback
  has_merit

  #redis counters
  counter :votes_counter
  counter :comments_counter
  counter :views_counter
  counter :shares_counter

  #redis list
  list :voters_ids
  list :commenters_ids

  #Rank
  sorted_set :leaderboard, global: true
  sorted_set :trending, global: true

  #Includes concerns
  include Commentable
  include Votable

  #Associations
  belongs_to :idea, -> {with_deleted}, touch: true
  belongs_to :user, -> {with_deleted}, touch: true

  #Tags for feedback
  acts_as_taggable_on :categories

  #Enums and states
  enum status: { posted: 0, badged: 1, flagged: 2 }
  enum badge: { initial: 0, helpful: 1, unhelpful: 2, irrelevant: 3 }

  public

  def idea_owner
    idea.user
  end

  private

  def update_counters
    #Update feedbacks counter for idea and user
    user.feedbacks_counter.reset
    user.feedbacks_counter.incr(user.feedbacks.size)
    idea.feedbackers_counter.reset
    idea.feedbackers_counter.incr(idea.feedbacks.size)
  end

  def cache_feedbacker_ids
    #Cache feedbacker id
    idea.feedbackers_ids << user_id unless idea.feedbacked?(user)
    #Add to leaderboard
    Feedback.leaderboard.add(id, points)
  end

  def delete_feedbacker_ids
    #Cache feedbacker id
    idea.feedbackers_ids.delete(user_id) if idea.feedbacked?(user)
    #Add to leaderboard
    Feedback.leaderboard.delete(id)
  end

  def create_activity
    # Enque activity creation
    CreateActivityJob.set(wait: 10.seconds).perform_later(id, self.class.to_s) if Activity.where(trackable: self).empty?
  end

  def delete_activity
    #Delete activity item from feed
    Activity.where(trackable_id: self.id, trackable_type: self.class.to_s).each do |activity|
      #Delete cached activities
      DeleteNotificationCacheService.new(activity).delete
      #finally destroy the activity
      activity.destroy if activity.present?
    end
  end

end
