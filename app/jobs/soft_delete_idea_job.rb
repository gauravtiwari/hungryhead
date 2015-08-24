class SoftDeleteIdeaJob < ActiveJob::Base

  def perform(idea)
    @idea = idea
    ActiveRecord::Base.connection_pool.with_connection do
      #Set idea state to default
      @idea.draft!
      @idea.me!

      #Rebuild counters for school
      @idea.school.ideas_counter.reset
      @idea.school.ideas_counter.incr(@school.get_published_ideas.length)

      #Rebuild counters for user
      @idea.user.ideas_counter.reset
      @idea.user.ideas_counter.incr(@user.ideas.size)

      #Insert into cache list
      Idea.latest.delete(@idea.id)
      Idea.trending.delete(@idea.id)
      Idea.leaderboard.delete(@idea.id)

      #Update publish date time
      @idea.published_date = nil
      @idea.save

    end
  end
end
