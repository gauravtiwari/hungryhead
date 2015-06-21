# reputation_change_observer.rb
class ReputationChangeObserver

  def update(changed_data)
    @description = changed_data[:description]

    # If user is your meritable model, you can query for it doing:
    resource = User.where(sash_id: changed_data[:sash_id]).first ||
      Idea.where(sash_id: changed_data[:sash_id]).first ||
      Feedback.where(sash_id: changed_data[:sash_id]).first

    resource.class.leaderboard[resource.id] = resource.points

    if resource.class.to_s == "User"
      user = resource
    elsif resource.class.to_s == "Idea"
      user = resource.user
      resource.update_attribute(investable: true) if resource.class.leaderboard[resource.id] > 1000
      resource.update_attribute(validated: true) if resource.class.leaderboard[resource.id] > 10000
    else
      user = resource.user
    end

  end

end