class UserUpdateListener

  def after_commit(user)
    if user.name_changed? || user.avatar_changed?
      RebuildNotificationsCacheJob.set(wait: 5.seconds).perform_later(user.id)
      User.where(ids: user.followers_ids.members | user.followings_ids.members).find_each do |user|
        RebuildNotificationsCacheJob.set(wait: 5.seconds).perform_later(user.id)
      end
    end
  end

end