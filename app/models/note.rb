class Note < ActiveRecord::Base
  belongs_to :user
  #Includes Modules
  include Redis::Objects
  #Includes concerns
  include Commentable
  include Shareable
  include Votable

  #Redis counters and cache
  counter :votes_counter
  sorted_set :voters_ids
  sorted_set :commenters_ids
  sorted_set :sharers_ids
  counter :shares_counter
  counter :comments_counter

  before_destroy :delete_activity

  private

  def delete_activity
    DeleteUserFeedJob.perform_later(self.id, self.class.to_s)
  end
end
