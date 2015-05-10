class Note < ActiveRecord::Base

  #Includes Modules
  include Redis::Objects

  belongs_to :user

  #Includes concerns
  include Commentable
  include Sluggable
  include Sharings
  include Votable

  #Redis counters and lists
  list :voters_ids
  list :commenters_ids
  list :sharers_ids
  #Counters
  counter :votes_counter
  counter :shares_counter
  counter :comments_counter

  #Model callbacks
  before_destroy :delete_activity

  public

  def can_score?
    true
  end

  private

  def slug_candidates
    [:title, [:title, :id]]
  end

  def delete_activity
    DeleteUserFeedJob.perform_later(self.id, self.class.to_s)
  end

end
