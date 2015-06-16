class UpdateSchoolCacheJob < ActiveJob::Base

  #JOB to rebuild cache for shareables
  def perform(id)
    @school = School.find(id)

    #reset all counters
    @school.people_counter.reset
    @school.ideas_counter.reset

    #rebuild all counters
    @school.people_counter.incr(@school.users.size)
    @school.ideas_counter.incr(@school.ideas.size)

  end

end