class Share < ActiveRecord::Base

	include Redis::Objects

  #Associations
  belongs_to :shareable, polymorphic: true
	belongs_to :user, touch: true

	#Includes concerns
	include Commentable
	include Votable

	#redis caching
	counter :votes_counter
	counter :comments_counter
	list :voters_ids
	list :commenters_ids

	before_destroy :decrement_counters, :delete_activity
	after_commit :increment_counters, on: :create

	#Store accessor methods
 	store_accessor :parameters, :shareable_name

 	#Enumerators to handle status
	enum status: {pending: 0, shared: 1}

	public

	def can_score?
		false
	end

	private

	def rebuild_cache
		#rebuild shareable cache counters and sharers ids
	  UpdateShareCacheJob.perform_later(shareable_id, shareable_type)
	end

	def increment_counters
		#Increment counters
		shareable.shares_counter.increment
		#Increment popularity score
		Idea.popular.increment(shareable_id) if shareable_type == "Idea"
		User.popular.increment(shareable_type == "Idea" ? shareable.student.id : shareable.user.id)
	  #Add sharer_id to shareable cache
	  shareable.sharers_ids << user_id
	end

	def decrement_counters
		#Decrement counters
		shareable.shares_counter.decrement
		#Decrement popularity score
		Idea.popular.decrement(shareable_id) if shareable_type == "Idea"
		User.popular.decrement(shareable_type == "Idea" ? shareable.student.id : shareable.user.id)
		#Delete sharer_id from shareable cache
	  shareable.sharers_ids.delete(user_id)
	end


	def delete_activity
		#Delete user feed
	  DeleteUserFeedJob.perform_later(self.id, self.class.to_s)
	end

end
