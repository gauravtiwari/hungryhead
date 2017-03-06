class Mention < ActiveRecord::Base
  belongs_to :mentionable, polymorphic: true
  belongs_to :mentioner, polymorphic: true, touch: true
  belongs_to :user

  before_destroy :delete_notification

  private

  def delete_notification
    Activity.where(
      trackable_id: id,
      trackable_type: self.class.to_s
    ).each do |activity|
      DeleteNotificationCacheService.new(activity).delete
      activity.destroy if activity.present?
    end
  end
end
