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
	sorted_set :voters_ids
	sorted_set :commenters_ids

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
