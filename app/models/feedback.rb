class Feedback < ActiveRecord::Base

  has_merit
  
  #Associations
  belongs_to :idea, touch: true
  belongs_to :user, touch: true

  #Enums and states
  enum status: { posted:0, badged:1, flagged:2 }

  store_accessor :parameters, :point_earned, :views_count

  #Included Modules
  acts_as_votable
  acts_as_commentable

  include PublicActivity::Model
  include Redis::Objects

  counter :comments_count
  counter :votes_count

  #Hooks
  before_destroy :remove_activity

  private

  def remove_activity
   PublicActivity::Activity.where(trackable_id: self.id, trackable_type: self.class.to_s).find_each do |activity|
    activity.destroy if activity.present?
    true
   end
  end

end
