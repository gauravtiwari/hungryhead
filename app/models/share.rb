class Share < ActiveRecord::Base

	include IdentityCache

  #Associations
  belongs_to :shareable, polymorphic: true
  counter_culture :shareable
	belongs_to :user, touch: true
	counter_culture :user

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

	#Caching Model
	cache_has_many :votes, :inverse_name => :votable, :embed => true
	cache_has_many :comments, :inverse_name => :commentable, embed: true

	before_destroy :decrement_counters, :delete_activity
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
