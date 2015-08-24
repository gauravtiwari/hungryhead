class Investment < ActiveRecord::Base

  include Redis::Objects

  #Model Callbacks
  before_destroy :cancel_investment, :update_counters, :delete_cached_investor_ids, :delete_activity
  after_commit  :update_balance, :update_counters, :cache_investor_ids, :create_activity, on: :create

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

  def update_counters
    #Increment counters
    user.investments_counter.reset
    user.investments_counter.incr(user.investments.size)
    idea.investors_counter.reset
    idea.investors_counter.incr(idea.investments.size)
  end

  def cache_investor_ids
    #Cache investor id into idea
    idea.investors_ids << user_id unless idea.invested?(user)
  end

  def delete_cached_investor_ids
    #Remove investor_id from idea cache
    idea.investors_ids.delete(user_id) if idea.invested?(user)
  end

  def create_activity
    CreateActivityJob.perform_later(id, self.class.to_s) if Activity.where(trackable: self).empty?
  end

  def delete_activity
    #remove activity from database and cache
    DeleteActivityJob.perform_later(self.id, self.class.to_s)
  end

end
