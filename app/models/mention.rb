class Mention < ActiveRecord::Base

  #Model relationships
  belongs_to :mentionable, -> {with_deleted}, polymorphic: true
  belongs_to :mentioner, -> {with_deleted}, polymorphic: true, touch: true
  belongs_to :user, -> {with_deleted}

  #Model callbacks
  before_destroy :delete_notification

  private

  def delete_notification
    #Delete notification
    Activity.where(trackable_id: self.id, trackable_type: self.class.to_s).each do |activity|
      #Delete cached activities
      DeleteNotificationCacheService.new(activity).delete
      #finally destroy the activity
      activity.destroy if activity.present?
    end
  end

end
