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
  cache_belongs_to :user
  cache_belongs_to :idea
  cache_index :uuid, unique: true

  #Includes concerns
  include Commentable
  include Votable

  #Model Callbacks
  after_destroy :cancel_investment, :decrement_counters, :delete_activity
  after_commit  :update_balance, :increment_counters, :create_activity, on: :destroy

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
    user.investments_counter.incr(user.investments.size)
    idea.investors_counter.incr(idea.investments.size)
    #Cache investor id into idea
    idea.investors_ids << user_id unless idea.invested?(user)
  end

  def create_activity
    CreateActivityJob.perform_later(id, self.class.to_s) if Activity.where(trackable: self).empty?
  end

  def decrement_counters
    #decrement counters
    user.investments_counter.incr(user.investments.size)
    idea.investors_counter.incr(idea.investments.size)
    #Remove investor_id from idea cache
    idea.investors_ids.delete(user_id) if idea.invested?(user)
  end

  def delete_activity
    #remove activity from database and cache
    DeleteActivityJob.perform_later(self.id, self.class.to_s)
  end

end
