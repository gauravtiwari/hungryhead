class Feedback < ActiveRecord::Base

  include Redis::Objects
  #Includes concerns
  include Commentable
  include Sharings
  include Votable

  has_merit

  #redis counters
  counter :votes_counter
  list :voters_ids
  list :commenters_ids
  counter :comments_counter

  #Associations
  belongs_to :idea, touch: true
  belongs_to :user, touch: true

  #Enums and states
  enum status: { posted:0, badged:1, flagged:2 }

  store_accessor :parameters, :point_earned, :views_count

  #Hooks
  before_destroy :decrement_counters, :remove_badge, :delete_activity
  after_commit :create_activity, :increment_counters, :award_badge, on: :create

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

  def create_activity
    CreateActivityJob.set(wait: 2.seconds).perform_later(self.id, self.class.to_s)
  end

  def award_badge
    AwardBadgeJob.set(wait: 5.seconds).perform_later(user.id, 3, "Feedback_#{id}") if user.first_feedback?
    AwardBadgeJob.set(wait: 5.seconds).perform_later(user.id, 5, "Feedback_#{id}") if user.feedback_30?
  end

  def remove_badge
    RemoveBadgeJob.set(wait: 5.seconds).perform_later(user.id, 3, "Feedback_#{id}") if user.first_feedback?
    RemoveBadgeJob.set(wait: 5.seconds).perform_later(user.id, 5, "Feedback_#{id}") if user.feedback_30?
  end

  def delete_activity
    #Delete activity item from feed
    DeleteUserFeedJob.set(wait: 5.seconds).perform_later(self.id, self.class.to_s)
  end

end
