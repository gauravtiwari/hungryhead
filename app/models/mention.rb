class Mention < ActiveRecord::Base
  belongs_to :mentionable, polymorphic: true
  belongs_to :mentioner, polymorphic: true
  belongs_to :user

  before_destroy :delete_user_feed

  private

  def delete_user_feed
    DeleteUserFeedJob.perform_later(self.id, self.class.to_s)
  end
end
