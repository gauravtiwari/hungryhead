class Share < ActiveRecord::Base

  #Don't delete straightaway
  acts_as_paranoid

  #redis objects
  include Redis::Objects
  #redis caching
  counter :votes_counter
  counter :comments_counter

  #Callbacks
  before_destroy :delete_activity
  after_create :create_activity


  #cached ids to redis
  list :voters_ids
  list :commenters_ids

  #Associations
  belongs_to :user, -> {with_deleted}, polymorphic: true

  #Includes concerns
  include Commentable
  include Votable

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