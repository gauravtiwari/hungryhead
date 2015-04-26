class Share < ActiveRecord::Base

  #Associations
  belongs_to :shareable, polymorphic: true
	belongs_to :user, touch: true
	#Includes concerns
	include Commentable
	include Votable

	#Store accessor methods
 	store_accessor :parameters, :shareable_name

 	#Enumerators to handle status
	enum status: {pending: 0, shared: 1}
	include Redis::Objects

	counter :votes_counter
	sorted_set :voters_ids
	sorted_set :commenters_ids
	counter :comments_counter

	before_destroy :remove_activity, :decrement_counters, :delete_activity
	after_create :increment_counters

	private

	def increment_counters
		shareable.shares_counter.increment
	  shareable.sharers_ids.add(user_id, created_at.to_i)
	end

	def decrement_counters
		shareable.shares_counter.decrement
	  shareable.sharers_ids.delete(user_id)
	end

	def delete_activity
	  DeleteUserFeedJob.perform_later(self.id, self.class.to_s)
	end

end
