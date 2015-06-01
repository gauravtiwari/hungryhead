class Post < ActiveRecord::Base

  #Includes Modules
  include Redis::Objects

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

  has_merit

  extend FriendlyId
  friendly_id :slug_candidates

  belongs_to :user

  #Includes concerns
  include Commentable
  include Sluggable
  include Sharings
  include Votable
  include Scorable

  #Model callbacks
  after_create :increment_counter
  before_save :add_uuid
  before_destroy :decrement_counter, :delete_activity

  public

  def can_score?
    true
  end

  private

  def slug_candidates
    [:uuid]
  end

  def should_generate_new_friendly_id?
    slug.blank? || uuid_changed?
  end

 def add_uuid
   self.uuid = "#{self.class.to_s.downcase}-#{self.id}" + SecureRandom.hex(6)
 end

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
