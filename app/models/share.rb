class Share < ActiveRecord::Base

  include Redis::Objects
  #redis caching
  counter :votes_counter
  counter :comments_counter
  #cached ids
  list :voters_ids
  list :commenters_ids

  #Associations
  belongs_to :shareable, polymorphic: true, touch: true
  belongs_to :owner, polymorphic: true

  #Includes concerns
  include Commentable
  include Votable

  before_destroy :decrement_counters, :delete_activity
  after_create :increment_counters, :create_activity

  public

  def can_score?
    false
  end

  #Get shareable user - idea(student) || user
  def shareable_user
    shareable_type == "Idea" ? shareable.student : shareable.user
  end

  private

  def create_activity
    CreateActivityJob.set(wait: 2.seconds).perform_later(id, self.class.to_s) if Activity.where(trackable: self).empty?
  end

  def increment_counters
    #Increment counters
    shareable.shares_counter.incr(shareable.shares.size)
    #Add sharer_id to shareable cache
    shareable.sharers_ids << user_id
  end

  def decrement_counters
    #Decrement counters
    shareable.shares_counter.incr(shareable.shares.size)
    #Delete sharer_id from shareable cache
    shareable.sharers_ids.delete(user_id)
  end


  def delete_activity
    #Delete user feed
    DeleteUserFeedJob.set(wait: 5.seconds).perform_later(self.id, self.class.to_s)
  end

end