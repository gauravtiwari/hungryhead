# reputation_change_observer.rb
class ReputationChangeObserver
  def update(changed_data)
    description = changed_data[:description]

    # If user is your meritable model, you can query for it doing:
    resource = User.where(sash_id: changed_data[:sash_id]).first ||
      Idea.where(sash_id: changed_data[:sash_id]).first ||
      Feedback.where(sash_id: changed_data[:sash_id]).first

    if resource.class.to_s == "User" || "Student" || "Teacher" || "Mentor"
      user = resource
    elsif resource.class.to_s == "Idea"
      user = resource.student
    else
      user = resource.user
    end

    CreateBadgeNotificationService.new(user, description).create
  end
end