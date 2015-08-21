class Share < ActiveRecord::Base

  #redis objects
  include Redis::Objects
  #redis caching
  counter :votes_counter
  counter :comments_counter

  #cached ids to redis
  list :voters_ids
  list :commenters_ids

  #Associations
  belongs_to :user, polymorphic: true

  #Includes concerns
  include Commentable
  include Votable

  before_destroy :delete_activity
  after_create :create_activity

  public

  def can_score?
    false
  end

  private

  def create_activity
    CreateActivityJob.set(wait: 10.seconds).perform_later(id, self.class.to_s) if Activity.where(trackable: self).empty?
  end

  def delete_activity
    #Delete user feed
    DeleteActivityJob.set(wait: 10.seconds).perform_later(self.id, self.class.to_s)
  end

end