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
end
