# reputation_change_observer.rb
class ReputationChangeObserver

  def update(changed_data)
    description = changed_data[:description]

    # If user is your meritable model, you can query for it doing:
    resource = User.where(sash_id: changed_data[:sash_id]).first ||
      Idea.where(sash_id: changed_data[:sash_id]).first ||
      Feedback.where(sash_id: changed_data[:sash_id]).first

    resource.class.leaderboard[resource.id] = resource.points

    if resource.class.to_s == "User" || resource.class.to_s == "Student" || resource.class.to_s == "Teacher" || resource.class.to_s == "Mentor"
      user = resource
    elsif resource.class.to_s == "Idea"
      user = resource.student
      resource.update_attribute!(investable: true) if resource.class.leaderboard[resource.id] > 1000
    else
      user = resource.user
    end

    Pusher.trigger_async("private-user-#{user.id}",
      "new_badge",
      {
        message:   "You have been #{description}"
      }.to_json
    )

  end

end