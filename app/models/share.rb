class Share < ActiveRecord::Base

  include IdentityCache
  #redis objects
  include Redis::Objects
  #redis caching
  counter :votes_counter
  counter :comments_counter
  #cached ids
  list :voters_ids
  list :commenters_ids

  #Associations
  belongs_to :owner, polymorphic: true
  cache_index :uuid

  #Includes concerns
  include Commentable
  include Votable

  before_destroy :delete_activity
  after_create :create_activity

  public

  def can_score?
    false
  end

  #Get shareable user - school(user) || user
  def shareable_user
    owner_type == "School" ? owner.user : owner
  end

  private

  def create_activity
    CreateActivityJob.set(wait: 2.seconds).perform_later(id, self.class.to_s) if Activity.where(trackable: self).empty?
  end


  def delete_activity
    #Delete user feed
    DeleteUserFeedJob.set(wait: 5.seconds).perform_later(self.id, self.class.to_s)
  end

end