class Investment < ActiveRecord::Base

  #Associations
  belongs_to :user, touch: true, counter_cache: true
  belongs_to :idea, touch: true, counter_cache: true

  store_accessor :parameters, :point_earned, :views_count

  #Includes modules
  acts_as_votable
  acts_as_commentable
  has_merit

	include PublicActivity::Model
	include Redis::Objects
	tracked only: [:create],
	owner: ->(controller, model) { controller && controller.current_user },
	recipient: ->(controller, model) { model && model.idea },
		params: {verb: "invested", action:  ->(controller, model) { model && model.amount }}

	counter :votes_counter
  sorted_set :voters_ids
	counter :comments_counter

	before_destroy :remove_activity
  before_destroy :cancel_investment
  after_create :increment_counters
  before_destroy :decrement_counters

	private

	def remove_activity
   PublicActivity::Activity.where(trackable_id: self.id, trackable_type: self.class.to_s).find_each do |activity|
    DeleteUserFeedJob.set(wait: 10.seconds).perform_later(activity)
   end
  end

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
