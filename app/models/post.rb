class Post < ActiveRecord::Base

  #Includes Modules
  include Redis::Objects
  has_merit

  #Redis counters and lists
  list :voters_ids
  list :commenters_ids
  list :sharers_ids

  #Counters
  counter :votes_counter
  counter :shares_counter
  counter :comments_counter
  counter :views_counter

  #rank
  sorted_set :leaderboard, global: true
  sorted_set :trending, global: true

  belongs_to :user

  #Includes concerns
  include Commentable
  include Sharings
  include Votable
  include Scorable

  #Model callbacks
  after_create :increment_counter
  before_destroy :decrement_counter, :delete_activity

  public

  def can_score?
    true
  end

  private

  def increment_counter
    user.posts_counter.increment
    Post.leaderboard.add(id, points)
  end

  def decrement_counter
    user.posts_counter.decrement
    Post.leaderboard.delete(id)
  end

  def delete_activity
    DeleteUserFeedJob.set(wait: 5.seconds).perform_later(self.id, self.class.to_s)
  end

end
