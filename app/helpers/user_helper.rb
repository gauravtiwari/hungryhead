module UserHelper
	def is_owner?(user)
		current_user == user
	end

  # Todo cleanup these keys
  def cache_key_for_users
    count = User.published.count
    max_updated_at = User.published.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "users/all-#{count}-#{max_updated_at}"
  end

  def cache_key_for_school_users(school)
    count = school.user.select{|u| u.state = "published"}.count
    max_updated_at = school.user.select{|u| u.state = "published"}.map(&:updated_at).max.try(:utc).try(:to_s, :number)
    "users/school-#{count}-#{max_updated_at}"
  end

  def cache_key_for_user(user)
    investments = user.investments_counter.value
    followers = user.followers_counter.value
    feedbacks = user.feedbacks_counter.value
    followed = user.followed_by?(current_user)
    "user-#{user.id}-#{user.updated_at.try(:to_s, :number)}/investments-#{investments}/followers-#{followers}/feedbacks-#{feedbacks}/followed-#{followed}"
  end
end
