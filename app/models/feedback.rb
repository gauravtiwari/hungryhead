class Feedback < ActiveRecord::Base

  has_merit

  #Associations
  belongs_to :idea, touch: true
  belongs_to :user, touch: true
  has_many :comments, as: :commentable, :dependent => :destroy
  has_many :votes, as: :votable, :dependent => :destroy
  has_many :shares, as: :shareable, dependent: :destroy, autosave: true

  #Enums and states
  enum status: { posted:0, badged:1, flagged:2 }

  store_accessor :parameters, :point_earned, :views_count

  include Redis::Objects

  counter :votes_counter
  sorted_set :voters_ids
  counter :comments_counter

  #Hooks
  before_destroy :remove_activity, :decrement_counters
  after_create :increment_counters

  private

  def remove_activity
   Activity.where(trackable_id: self.id, trackable_type: self.class.to_s).find_each do |activity|
    DeleteUserFeedJob.perform_later(activity)
   end
  end

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

end
