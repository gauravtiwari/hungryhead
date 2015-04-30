class UserUpdateListener

  def after_commit(user)
    if user.previous_changes[:name].present? || user.previous_changes[:avatar].present?
      RebuildNotificationsCacheJob.set(wait: 5.seconds).perform_later(user.id)
      User.where(id: user.followers_ids.members | user.followings_ids.members).find_each do |user|
        RebuildNotificationsCacheJob.set(wait: 5.seconds).perform_later(user.id)
      end
    end
  end

end