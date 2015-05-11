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

  #Includes concerns
  include Commentable
  include Sharings
  include Votable
  include Mentioner

  #Associations
  belongs_to :idea, touch: true
  belongs_to :user, touch: true

  #Tags for feedback
  acts_as_taggable_on :tags

  #Enums and states
  enum status: { posted:0, badged:1, flagged:2 }

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
    #Increment popularity score
    Idea.popular.increment(idea_id)
    User.popular.increment(idea.student.id)
    #Cache feedbacker id
    idea.feedbackers_ids << user_id
  end

  def decrement_counters
    #Decrement feedbacks counter for idea and user
    user.feedbacks_counter.decrement if user.feedbacks_counter.value > 0
    idea.feedbackers_counter.decrement if idea.feedbackers_counter.value > 0
    #Decrement popularity score
    Idea.popular.decrement(idea_id)
    User.popular.decrement(idea.student.id)
    #Remove cached feedbacker id
    idea.feedbackers_ids.delete(user_id)
  end

  def delete_activity
    #Delete activity item from feed
    DeleteUserFeedJob.set(wait: 5.seconds).perform_later(self.id, self.class.to_s)
  end

end
