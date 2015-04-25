class Share < ActiveRecord::Base

  #Associations
  belongs_to :shareable, polymorphic: true
	belongs_to :user, touch: true
	has_many :comments, as: :commentable, :dependent => :destroy
	has_many :votes, as: :votable, :dependent => :destroy

	#Store accessor methods
 	store_accessor :parameters, :shareable_name

 	#Enumerators to handle status
	enum status: {pending: 0, shared: 1}
	include Redis::Objects

	counter :votes_counter
	sorted_set :voters_ids

	before_destroy :remove_activity, :decrement_counters
	after_create :increment_counters

	private

	def remove_activity
	 Activity.where(trackable_id: self.id, trackable_type: self.class.to_s).find_each do |activity|
	  activity.destroy if activity.present?
	  true
	 end
	end

	def increment_counters
		shareable.shares_counter.increment
	  shareable.sharers_ids.add(user_id, created_at.to_i)
	end

	def decrement_counters
		shareable.shares_counter.decrement
	  shareable.sharers_ids.delete(user_id)
	end

end
