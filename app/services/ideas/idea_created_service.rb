class IdeaCreatedService

  def initialize(idea)
    @idea = idea
  end

  def call
    increment_counters
  end

  def increment_counters
    #Increment counters for school and student
    @idea.school.ideas_counter.increment if @idea.school
    @idea.student.ideas_counter.increment if @idea.student
    #Cache latest ideas into a list for user and school, max: 20
    @idea.student.latest_ideas <<  @idea.id if @idea.student
    @idea.school.latest_ideas << @idea.id if @idea.school
    #Insert into cache list
    Idea.latest << @idea.id
    Idea.trending.add(@idea.id, 1)
    Idea.leaderboard.add(@idea.id, @idea.points)
  end

end