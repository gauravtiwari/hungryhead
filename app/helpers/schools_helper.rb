module SchoolsHelper

  def cache_key_for_schools
    count          = School.count
    max_updated_at = School.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "ideas/published-#{count}-#{max_updated_at}"
  end

  def cache_key_for_school(school)
    people = school.people_counter.value
    followers = school.followers_counter.value
    ideas = school.ideas_counter.value
    followed = school.followed_by(current_user)
    "#{school}/people-#{people}/followers-#{followers}/ideas-#{ideas}/followed-#{followed}"
  end

end
