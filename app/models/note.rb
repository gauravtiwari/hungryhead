class Note < ActiveRecord::Base

  #Includes Modules
  include IdentityCache
  include Redis::Objects

  belongs_to :user

  #Includes concerns
  include Commentable
  include Sharings
  include Votable

  #Redis counters and cache
  counter :votes_counter
  sorted_set :voters_ids
  sorted_set :commenters_ids
  sorted_set :sharers_ids
  counter :shares_counter
  counter :comments_counter

  #Caching Model
  cache_has_many :votes, :inverse_name => :votable, :embed => true
  cache_has_many :comments, :inverse_name => :commentable, embed: true
  cache_has_many :shares, :inverse_name => :shareable, embed: true

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
