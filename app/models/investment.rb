class Investment < ActiveRecord::Base

  include IdentityCache
  include Redis::Objects

  #Associations
  belongs_to :user, touch: true
  belongs_to :idea, touch: true

  #Includes concerns
  include Commentable
  include Votable

  #Model Callbacks
  before_destroy :cancel_investment, :decrement_counters, :delete_activity
  after_commit :increment_counters, on: :create

  #Store accessor methods
  store_accessor :parameters, :point_earned, :views_count

  #Includes modules
  has_merit

  #Caching Model
  cache_has_many :votes, :inverse_name => :votable, :embed => true
  cache_has_many :comments, :inverse_name => :commentable, embed: true

  public

  def can_score?
    false
  end

	private

  def cancel_investment
    idea.update_attributes!(fund: {"balance" => idea.balance - amount }) if idea.balance > 0
    user.update_attributes!(fund: {"balance" => user.balance + amount })
  end

  def increment_counters
    user.investments_counter.increment
    idea.investors_counter.increment
    Idea.popular.increment(idea_id)
    User.popular.increment(idea.student.id)
    idea.investors_ids << user.id
  end

  def decrement_counters
    user.investments_counter.decrement if user.investments_counter.value > 0
    idea.investors_counter.decrement if idea.investors_counter.value > 0
    Idea.popular.decrement(idea_id)
    User.popular.decrement(idea.student.id)
    idea.investors_ids.delete(user.id)
  end

  def delete_activity
    DeleteUserFeedJob.perform_later(self.id, self.class.to_s)
  end

end
