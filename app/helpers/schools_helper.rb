module SchoolsHelper

  def cache_key_for_school(school)
    people = school.people_counter.value
    followers = school.followers_counter.value
    ideas = school.ideas_counter.value
    followed = school.followed_by?(current_user)
    "school-#{school.updated_at.to_i}/people-#{people}/followers-#{followers}/ideas-#{ideas}/followed-#{followed}"
  end

end
