class Feedback < ActiveRecord::Base

  include Redis::Objects

  #redis counters
  counter :votes_counter
  counter :comments_counter
  counter :views_counter

  #redis list
  list :voters_ids
  list :commenters_ids

  #Rank
  sorted_set :leaderboard, global: true
  sorted_set :trending, global: true

  #Includes concerns
  include Commentable
  include Sharings
  include Votable
  include Mentioner

  has_merit

  #Associations
  belongs_to :idea, touch: true
  belongs_to :user, touch: true

  #Tags for feedback
  acts_as_taggable_on :tags

  #Enums and states
  enum status: { posted:0, accepted: 1, rejected: 2, flagged: 3 }

  store_accessor :parameters, :tags

  #Hooks
  before_destroy :decrement_counters, :delete_activity
  after_commit :increment_counters, on: :create

  public

  def can_score?
    true
  end

  private

  def increment_counters
    #Increment feedbacks counter for idea and user
    user.feedbacks_counter.increment
    idea.feedbackers_counter.increment
    #Cache feedbacker id
    idea.feedbackers_ids << user_id
  end

  def decrement_counters
    #Decrement feedbacks counter for idea and user
    user.feedbacks_counter.decrement if user.feedbacks_counter.value > 0
    idea.feedbackers_counter.decrement if idea.feedbackers_counter.value > 0
    #Remove cached feedbacker id
    idea.feedbackers_ids.delete(user_id)
  end

  def delete_activity
    #Delete activity item from feed
    DeleteUserFeedJob.set(wait: 5.seconds).perform_later(self.id, self.class.to_s)
  end

end
