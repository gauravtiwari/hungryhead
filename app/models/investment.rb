class Investment < ActiveRecord::Base
  	
  	#Associations
  	belongs_to :user, counter_cache: true, touch: true
  	belongs_to :idea, counter_cache: true, touch: true

  	store_accessor :parameters, :point_earned, :views_count

  	#Includes modules
 	acts_as_votable
  	acts_as_commentable
  	has_merit

	include PublicActivity::Model
	before_destroy :remove_activity
	
	private

	def remove_activity
	 PublicActivity::Activity.where(trackable_id: self.id, trackable_type: self.class.to_s).find_each do |activity|
	  activity.destroy if activity.present?
	  true
	 end
	end

end
