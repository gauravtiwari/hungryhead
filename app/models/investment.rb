class Investment < ActiveRecord::Base

  include IdentityCache
  include Redis::Objects

  #Associations
  belongs_to :user, touch: true
  belongs_to :idea, touch: true

  #Includes concerns
  include Commentable
  include Votable

  #Counters for redis
  counter :votes_counter
  list :voters_ids
  list :commenters_ids
  counter :comments_counter

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
    #Update idea and user balance
    idea.update_attributes!(fund: {"balance" => idea.balance - amount }) if idea.balance > 0
    user.update_attributes!(fund: {"balance" => user.balance + amount })
  end

  def increment_counters
    #Increment counters
    user.investments_counter.increment
    idea.investors_counter.increment
    #Increment popularity score
    Idea.popular.increment(idea_id)
    User.popular.increment(idea.student.id)
    #Cache investor id into idea
    idea.investors_ids << user_id
  end

  def decrement_counters
    #decrement counters
    user.investments_counter.decrement if user.investments_counter.value > 0
    idea.investors_counter.decrement if idea.investors_counter.value > 0
    #Decrement popularity score
    Idea.popular.decrement(idea_id)
    User.popular.decrement(idea.student.id)
    #Remove investor_id from idea cache
    idea.investors_ids.delete(user_id)
  end

  def delete_activity
    #remove activity from database and cache
    DeleteUserFeedJob.perform_later(self.id, self.class.to_s)
  end

end
