class Note < ActiveRecord::Base

  #Includes Modules
  include IdentityCache
  include Redis::Objects

  belongs_to :user

  #Includes concerns
  include Commentable
  include Sharings
  include Votable

  #Model callbacks
  before_destroy :delete_activity

  public

  def can_score?
    true
  end

  private

  def delete_activity
    DeleteUserFeedJob.perform_later(self.id, self.class.to_s)
  end

end
