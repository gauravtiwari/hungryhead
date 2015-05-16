module IdeaConcerns

  included do

    acts_as_taggable_on :markets, :locations, :technologies

    #Enumerators for handling states
    enum status: { draft:0, published:1, reviewed:2 }
    enum privacy: { me:0, everyone:2 }

    #included modules
    include Redis::Objects
    before_destroy :decrement_counters, :remove_from_soulmate, :delete_activity

    #Cache ids of followers, voters, sharers, feedbackers, investors and activities
    set :followers_ids
    list :voters_ids
    list :sharers_ids
    list :feedbackers_ids
    list :investors_ids
    list :commenters_ids

    #Set to store trending
    list :latest, maxlength: 20, marshal: true, global: true

    #Store latest idea notifications
    sorted_set :ticker, maxlength: 100, marshal: true

    #Leaderboard ideas
    sorted_set :leaderboard, global: true
    sorted_set :trending, global: true

    #Redis Cache counters
    counter :followers_counter
    counter :investors_counter
    counter :feedbackers_counter
    counter :views_counter
    counter :votes_counter
    counter :shares_counter
    counter :comments_counter

  end

  def remove_from_soulmate
    loader = Soulmate::Loader.new("ideas")
    loader.remove("id" => id)
  end

  def decrement_counters
    #Decrement counters for student and school
    school.ideas_counter.decrement
    student.ideas_counter.decrement
    #Remove self from cached list
    student.latest_ideas.delete(id)
    school.latest_ideas.delete(id)
    #Remove self from sorted set
    Idea.latest.delete(id)
    Idea.trending.delete(id)
    Idea.leaderboard.delete(id)
  end

  def delete_activity
    #Delete idea time from user feed
    DeleteUserFeedJob.set(wait: 5.seconds).perform_later(self.id, self.class.to_s)
  end

end