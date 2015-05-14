class Share < ActiveRecord::Base

	include Redis::Objects
	#redis caching
	counter :votes_counter
	counter :comments_counter
	#cached ids
	list :voters_ids
	list :commenters_ids

	#Associations
	belongs_to :shareable, polymorphic: true
	belongs_to :user, touch: true

	#Includes concerns
	include Commentable
	include Votable

	before_destroy :decrement_counters, :delete_activity
	after_commit :increment_counters, on: :create

	#Store accessor methods
	store_accessor :parameters, :shareable_name

	#Enumerators to handle status
	enum status: {shared: 0}

	public

	def can_score?
		false
	end

	#Get commulative score
	def cummulative_score
	  votes_score + comments_score
	end

	#Get shareable user - idea(student) || user
	def shareable_user
	  shareable_type == "Idea" ? shareable.student : shareable.user
	end

	private

	def rebuild_cache
		#rebuild shareable cache counters and sharers ids
	  UpdateShareCacheJob.perform_later(shareable_id, shareable_type)
	end

	def increment_counters
		#Increment counters
		shareable.shares_counter.increment
	  #Add sharer_id to shareable cache
	  shareable.sharers_ids << user_id
	end

	def decrement_counters
		#Decrement counters
		shareable.shares_counter.decrement
		#Delete sharer_id from shareable cache
	  shareable.sharers_ids.delete(user_id)
	end


	def delete_activity
		#Delete user feed
	  DeleteUserFeedJob.set(wait: 5.seconds).perform_later(self.id, self.class.to_s)
	end

end
