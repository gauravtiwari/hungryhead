class ReputationChangeObserver
  def update(changed_data)
    @description = changed_data[:description]
    # If user is your meritable model, you can query for it doing:
    resource = User.where(sash_id: changed_data[:sash_id]).first ||
               Idea.where(sash_id: changed_data[:sash_id]).first ||
               Feedback.where(sash_id: changed_data[:sash_id]).first

    resource.class.leaderboard[resource.id] = resource.points

    # Update resources if leaderboard changes
    if resource.class.to_s == 'User'
      resource
    elsif resource.class.to_s == 'Idea'
      resource.user
      resource.update_attributes(investable: true) if resource.class.leaderboard[resource.id] > 999
      resource.update_attributes(validated: true) if resource.class.leaderboard[resource.id] > 9999
    else
      resource.user
    end
  end
end
