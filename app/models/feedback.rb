class Feedback < ActiveRecord::Base

  include IdentityCache
  include Redis::Objects
  #Includes concerns
  include Commentable
  include Sharings
  include Votable

  has_merit

  #Associations
  belongs_to :idea, touch: true
  belongs_to :user, touch: true

  #Enums and states
  enum status: { posted:0, badged:1, flagged:2 }

  store_accessor :parameters, :point_earned, :views_count

  #Hooks
  before_destroy :decrement_counters, :delete_activity
  after_commit :increment_counters, on: :create

  public

  def can_score?
    true
  end

  private

  def increment_counters
    user.feedbacks_counter.increment
    idea.feedbackers_counter.increment
    Idea.popular.increment(idea_id)
    User.popular.increment(idea.student.id)
    idea.feedbackers_ids << user.id
  end

  def decrement_counters
    user.feedbacks_counter.decrement if user.feedbacks_counter.value > 0
    idea.feedbackers_counter.decrement if idea.feedbackers_counter.value > 0
    Idea.popular.decrement(idea_id)
    User.popular.decrement(idea.student.id)
    idea.feedbackers_ids.delete(user.id)
  end

  def delete_activity
    DeleteUserFeedJob.perform_later(self.id, self.class.to_s)
  end

end
