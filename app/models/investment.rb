class Investment < ActiveRecord::Base

  #Associations
  belongs_to :user, touch: true
  belongs_to :idea, touch: true

  #Includes concerns
  include Commentable
  include Votable

  #Store accessor methods
  store_accessor :parameters, :point_earned, :views_count

  #Includes modules
  has_merit

	include Redis::Objects
	counter :votes_counter
  sorted_set :voters_ids
	counter :comments_counter

  #Model Callbacks
	before_destroy :cancel_investment, :decrement_counters
  after_create :increment_counters

	private

  def cancel_investment
    idea.update_attributes(fund: {"balance" => idea.balance - amount })
    user.update_attributes(fund: {"balance" => user.balance + amount })
  end

  def increment_counters
    user.investments_counter.increment
    idea.investors_counter.increment
  end

  def decrement_counters
    user.investments_counter.decrement if user.investments_counter.value > 0
    idea.investors_counter.decrement if idea.investors_counter.value > 0
    idea.investors.delete(user.id.to_s)
    idea.save
  end

end
