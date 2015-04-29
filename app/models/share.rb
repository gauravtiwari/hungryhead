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

	#Caching Model
	cache_has_many :votes, :inverse_name => :votable, :embed => true
	cache_has_many :comments, :inverse_name => :commentable, embed: true

	before_destroy :remove_cache_ids, :delete_activity
	after_commit :cache_ids, :update_activity_score, on: :create

	public

	def can_score?
		false
	end

	private

	def cache_ids
	  shareable.sharers_ids.push(user_id)
	  shareable.score + 1 if shareable.can_score?
	  user.score + 1
	  save_cache
	end

	def remove_cache_ids
	  shareable.sharers_ids.delete(user_id.to_s)
	  shareable.score - 1 if shareable.can_score?
	  user.score - 1
	  save_cache
	end

	def update_activity_score
	  @activity = Activity.find_by_recipient_id_and_recipient_type(shareable)
	  @activity.score = score + 1
	  @activity.save
	end

	def save_cache
		shareable.save
		user.save
	end

	def delete_activity
	  DeleteUserFeedJob.perform_later(self.id, self.class.to_s)
	end

end
