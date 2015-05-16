module UserConcerns

  included do
    #included modules
    include Redis::Objects
    #Tagging System
    acts_as_taggable_on :hobbies, :locations, :subjects, :markets
    acts_as_tagger

    #Sorted set to store followers, followings ids and latest activities
    set :followers_ids
    set :followings_ids
    set :idea_followings_ids
    set :school_followings_ids

    #Latest ideas
    list :latest_ideas, maxlength: 5, marshal: true
    #List to store latest users
    list :latest, maxlength: 20, marshal: true, global: true

    #Store latest user notifications
    sorted_set :ticker, marshal: true
    sorted_set :friends_notifications, marshal: true

    #List to store last 10 activities
    list :latest_activities, maxlength: 5, marshal: true

    #Sorted set to store trending ideas
    sorted_set :leaderboard, global: true
    sorted_set :trending, global: true

    #Redis counters to cache total followers, followings,
    #feedbacks, investments and ideas
    counter :followers_counter
    counter :followings_counter

    counter :feedbacks_counter
    counter :investments_counter

    counter :comments_counter
    counter :votes_counter
    counter :ideas_counter
    counter :posts_counter
    counter :views_counter
    counter :shares_counter

    #Enumerators to handle states
    enum state: { inactive: 0, published: 1}
    enum role: { user: 0, student: 1, entrepreneur: 2, mentor: 3, teacher: 4 }

  end


  def remove_from_soulmate
    #Remove search index if :record destroyed
    loader = Soulmate::Loader.new("students")
    loader.remove("id" => id)
  end

  def decrement_counters
    #Decrement counters
    school.students_counter.decrement if school_id.present? && school.students_counter.value > 0 && self.type == "Student"
    #delete cached lists for school
    school.latest_students.delete(id) if school_id.present? && self.type == "Student"
    school.latest_faculties.delete(id) if school_id.present? && self.type == "Teacher"
    #delete cached sorted set for global leaderboard
    User.latest.delete(id) unless type == "User"

    #delete leaderboard for this user
    User.leaderboard.delete(id)
    User.trending.delete(id)
  end

  #Deletes all dependent activities for this user
  def delete_activity
    DeleteUserFeedJob.set(wait: 5.seconds).perform_later(self.id, self.class.to_s)
  end

end