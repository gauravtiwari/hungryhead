class UserUpdateListener

  def after_commit(user)
    if user.previous_changes[:name].present? || user.previous_changes[:avatar].present?
      unless user.admin?
        #rebuild user feed after every name and avatar update.
        RebuildNotificationsCacheJob.set(wait: 5.seconds).perform_later(user.id)
        #Find all followers and followings and update their feed.
        User.where(id: user.followers_ids.members | user.followings_ids.members).find_each do |user|
          RebuildNotificationsCacheJob.set(wait: 5.seconds).perform_later(user.id)
        end
      end
    end
  end

end

