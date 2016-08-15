class Investment < ActiveRecord::Base
  include Redis::Objects

  before_destroy :cancel_investment, :update_counters,
  :delete_cached_investor_ids, :delete_activity
  after_commit  :update_balance, :update_counters,
  :cache_investor_ids, :create_activity, on: :create

  counter :votes_counter
  list :voters_ids
  list :commenters_ids
  counter :comments_counter

  belongs_to :user, touch: true
  belongs_to :idea, touch: true

  include Commentable
  include Votable

  public

	private

  def cancel_investment
    idea.update_attributes!(
      fund: {"balance" => idea.balance - amount }
    ) if idea.balance > 0

    user.update_attributes!(
      fund: {"balance" => user.balance + amount }
    )
  end

  def update_balance
    UpdateInvestmentBalanceJob.perform_later(id)
  end

  def update_counters
    user.investments_counter.reset
    user.investments_counter.incr(user.investments.size)
    idea.investors_counter.reset
    idea.investors_counter.incr(idea.investments.size)
    true
  end

  def cache_investor_ids
    idea.investors_ids << user_id unless idea.invested?(user)
  end

  def delete_cached_investor_ids
    idea.investors_ids.delete(user_id) if idea.invested?(user)
    true
  end

  def create_activity
    CreateActivityJob.perform_later(
      id, self.class.to_s
    ) if Activity.where(trackable: self).empty?
  end

  def delete_activity
    Activity.where(
      trackable_id: self.id,
      trackable_type: self.class.to_s
    ).each do |activity|
      DeleteNotificationCacheService.new(activity).delete
      activity.destroy if activity.present?
    end
  end

end
