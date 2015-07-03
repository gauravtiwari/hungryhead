class Feedback < ActiveRecord::Base

  include IdentityCache
  include Redis::Objects

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
  belongs_to :idea, touch: true
  belongs_to :user, touch: true
  cache_belongs_to :user
  cache_belongs_to :idea
  cache_index :uuid, unique: true

  #Tags for feedback
  acts_as_taggable_on :tags

  #Enums and states
  enum status: { posted: 0, badged: 1, flagged: 2 }
  enum badge: { initial: 0, helpful: 1, unhelpful: 2, irrelevant: 3 }

  #Hooks
  after_destroy :update_counters, :delete_feedbacker_ids, :delete_activity
  after_commit :update_counters, :cache_feedbacker_ids, :create_activity, on: :create

  public

  def can_score?
    true
  end

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
    CreateActivityJob.perform_later(id, self.class.to_s) if Activity.where(trackable: self).empty?
  end

  def delete_activity
    #Delete activity item from feed
    DeleteActivityJob.perform_later(self.id, self.class.to_s)
  end

end
