class Follow < ActiveRecord::Base

  #Hooks
  after_commit :update_counters, :create_activity, :cache_follow_ids, on: :create
  before_destroy :update_counters, :delete_cache_follow_ids, :delete_activity

  #relations
  belongs_to :follower, class_name: 'User', foreign_key: 'follower_id'
  belongs_to :followable, polymorphic: true, touch: true

  # Validations
  validates :followable, presence: true
  validates :follower, presence: true

  #Scopes for fetching records
  scope :followings_for, ->(follower, followable) {
    where(
      follower_id: follower.id,
      followable_id: followable.id,
      followable_type: followable.class.to_s
    )
  }

  private

  #Redis Counters
  def update_counters
   follower.followings_counter.reset
   follower.followings_counter.incr(follower.followings.size)
   followable.followers_counter.reset
   followable.followers_counter.incr(followable.followers.size)
   true
  end

  #Create activity
  def create_activity
    CreateActivityJob.set(wait: 10.seconds).perform_later(id, self.class.to_s) if Activity.where(trackable: self).empty?
  end

  #Add ids to follower and followable cache
  def cache_follow_ids
    follower.followings_ids << followable_id if followable_type == "User"
    follower.school_followings_ids << followable_id if followable_type == "School"
    followable.followers_ids << follower_id
  end

  def delete_cache_follow_ids
    #Delete cached ids
    follower.followings_ids.delete(followable_id) if followable_type == "User"
    follower.school_followings_ids.delete(followable_id) if followable_type == "School"
    followable.followers_ids.delete(follower_id)
    true
  end

  def delete_activity
    DeleteActivityJob.set(wait: 10.seconds).perform_later(self.id, self.class.to_s) unless followable_type == "School"
  end

end