class Feedback < ActiveRecord::Base

  #Includes concerns
  include Commentable
  include Shareable
  include Votable

  has_merit

  #Associations
  belongs_to :idea, touch: true
  belongs_to :user, touch: true

  #Enums and states
  enum status: { posted:0, badged:1, flagged:2 }

  store_accessor :parameters, :point_earned, :views_count

  include Redis::Objects

  counter :votes_counter
  sorted_set :voters_ids
  sorted_set :commenters_ids
  counter :comments_counter

  #Hooks
  before_destroy :decrement_counters, :delete_activity
  after_create :increment_counters

  private

  def increment_counters
    user.feedbacks_counter.increment
    idea.feedbackers_counter.increment
    idea.feedbackers.push(user.id)
    idea.save
  end

  def decrement_counters
    user.feedbacks_counter.decrement if user.feedbacks_counter.value > 0
    idea.feedbackers_counter.decrement if idea.feedbackers_counter.value > 0
    idea.feedbackers.delete(user.id.to_s)
    idea.save
  end

  def delete_activity
    DeleteUserFeedJob.perform_later(self.id, self.class.to_s)
  end

end
