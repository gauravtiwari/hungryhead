class Share < ActiveRecord::Base

	include IdentityCache
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
	after_create :increment_counters

	#Store accessor methods
 	store_accessor :parameters, :shareable_name

 	#Enumerators to handle status
	enum status: {pending: 0, shared: 1}

	#Caching Model
	cache_has_many :votes, :inverse_name => :votable, :embed => true
	cache_has_many :comments, :inverse_name => :commentable, embed: true

	public

	def can_score?
		false
	end

	private

	def rebuild_cache
	  UpdateShareCacheJob.perform_later(shareable_id, shareable_type)
	end

	def increment_counters
		shareable.shares_counter.increment
		Idea.popular.increment(shareable_id) if shareable_type == "Idea"
		User.popular.increment(shareable_type == "Idea" ? shareable.student.id : shareable.user.id)
	  shareable.sharers_ids << user_id
	end

	def decrement_counters
		shareable.shares_counter.decrement
		Idea.popular.decrement(shareable_id) if shareable_type == "Idea"
		User.popular.decrement(shareable_type == "Idea" ? shareable.student.id : shareable.user.id)
	  shareable.sharers_ids.delete(user_id)
	end


	def delete_activity
	  DeleteUserFeedJob.perform_later(self.id, self.class.to_s)
	end

end
