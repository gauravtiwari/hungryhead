class Share < ActiveRecord::Base
  include Redis::Objects

  counter :votes_counter
  counter :comments_counter

  before_destroy :delete_activity
  after_create :create_activity

  list :voters_ids
  list :commenters_ids

  belongs_to :user, polymorphic: true

  include Commentable
  include Votable

  private

  def create_activity
    CreateActivityJob.set(
      wait: 10.seconds
    ).perform_later(id, self.class.to_s) if Activity.where(trackable: self).empty?
  end

  def delete_activity
    Activity.where(
      trackable_id: self.id,
      trackable_type: self.class.to_s
    ).each do |activity|
      DeleteNotificationCacheService.new(activity).delete
      activity.destroy if activity.present?
    end
  end

end
