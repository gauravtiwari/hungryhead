class Share < ActiveRecord::Base
  	#Associations
  	belongs_to :shareable, polymorphic: true, counter_cache: true
	belongs_to :user, touch: true, counter_cache: true
 	store_accessor :parameters, :shareable_name

 	#Enumerators to handle status
	enum status: {pending: 0, shared: 1}

	acts_as_votable

	include PublicActivity::Model
	tracked only: [:create],
	owner: ->(controller, model) { controller && controller.current_user },
	recipient: ->(controller, model) { model && model.shareable.student }
	
	before_destroy :remove_activity

	private

	def remove_activity
	 PublicActivity::Activity.where(trackable_id: self.id, trackable_type: self.class.to_s).find_each do |activity|
	  activity.destroy if activity.present?
	  true
	 end
	end
end
