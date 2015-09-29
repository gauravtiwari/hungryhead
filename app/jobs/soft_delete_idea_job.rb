class SoftDeleteIdeaJob < ActiveJob::Base

  def perform(idea)
    @idea = idea
    ActiveRecord::Base.connection_pool.with_connection do
      #Set idea state to default
      @idea.draft!
      @idea.team!

      #Rebuild counters for school
      @idea.school.ideas_counter.reset
      @idea.school.ideas_counter.incr(@idea.school.get_published_ideas.length)

      #Rebuild counters for user
      @idea.user.ideas_counter.reset
      @idea.user.ideas_counter.incr(@idea.user.ideas.size)

      #Insert into cache list
      Idea.latest.delete(@idea.id)
      Idea.trending.delete(@idea.id)
      Idea.leaderboard.delete(@idea.id)

      #Update publish date time
      @idea.published_date = nil
      @idea.save

      #Finally set the idea for destruction in a day
      DestroyRecordJob.set(wait: 1.day).perform_later(@idea)
    end
  end
end
