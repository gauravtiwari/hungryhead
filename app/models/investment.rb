class Investment < ActiveRecord::Base

  include IdentityCache
  include Redis::Objects

  #Counters for redis
  counter :votes_counter
  list :voters_ids
  list :commenters_ids
  counter :comments_counter

  #Associations
  belongs_to :user, touch: true
  belongs_to :idea, touch: true

  #Includes concerns
  include Commentable
  include Votable

  #Model Callbacks
  before_destroy :cancel_investment, :decrement_counters, :delete_activity
  after_create  :update_balance, :increment_counters, :create_activity

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

  def update_balance
    UpdateInvestmentBalanceJob.perform_later(id)
  end

  def increment_counters
    #Increment counters
    user.investments_counter.increment
    idea.investors_counter.increment
    #Cache investor id into idea
    idea.investors_ids << user_id
  end

  def create_activity
    CreateActivityJob.perform_later(id, self.class.to_s)
  end

  def decrement_counters
    #decrement counters
    user.investments_counter.decrement if user.investments_counter.value > 0
    idea.investors_counter.decrement if idea.investors_counter.value > 0
    #Remove investor_id from idea cache
    idea.investors_ids.delete(user_id)
  end

  def delete_activity
    #remove activity from database and cache
    DeleteActivityJob.perform_later(self.id, self.class.to_s)
  end

end
