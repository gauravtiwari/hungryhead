class Investment < ActiveRecord::Base

  include Redis::Objects
  #Counters for redis
  counter :votes_counter
  list :voters_ids
  list :commenters_ids
  counter :comments_counter

  #Associations
  belongs_to :user
  belongs_to :idea

  #Includes concerns
  include Sluggable
  include Commentable
  include Votable

  #Model Callbacks
  before_destroy :cancel_investment, :decrement_counters, :delete_activity
  after_create  :increment_counters

  #Store accessor methods
  store_accessor :parameters, :point_earned, :views_count

  public

  def can_score?
    false
  end

	private

  def should_generate_new_friendly_id?
    slug.blank? || uuid_changed?
  end

  def slug_candidates
    [:uuid]
  end

  def cancel_investment
    #Update idea and user balance
    idea.update_attributes!(fund: {"balance" => idea.balance - amount }) if idea.balance > 0
    user.update_attributes!(fund: {"balance" => user.balance + amount })
  end

  def increment_counters
    #Increment counters
    user.investments_counter.increment
    idea.investors_counter.increment
    #Cache investor id into idea
    idea.investors_ids << user_id
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
    DeleteUserFeedJob.set(wait: 5.seconds).perform_later(self.id, self.class.to_s)
  end

end
