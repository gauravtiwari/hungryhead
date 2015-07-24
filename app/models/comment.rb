class Comment < ActiveRecord::Base

  include Redis::Objects

  #Redis counters and ids cache
  counter :votes_counter
  list :voters_ids

  acts_as_nested_set :scope => [:commentable_id, :commentable_type]

  validates :body, :presence => true
  validates :commentable, :presence => true
  validates :user, :presence => true

  include Votable
  include Mentioner

  #Callback hooks
  after_commit :update_counters, :cache_commenters_ids, :create_activity,  on: :create
  after_destroy :update_counters, :deleted_cached_commenters_ids, :delete_notification

  #Model Associations
  belongs_to :user
  belongs_to :commentable, :polymorphic => true, touch: true

  #Model Scopes
  default_scope -> { order('created_at DESC') }

  # Helper class method that allows you to build a comment
  # by passing a commentable object, a user_id, and comment text
  # example in readme
  def self.build_from(obj, user_id, comment)
    new \
      :commentable => obj,
      :body        => comment,
      :user_id     => user_id
  end

  #helper method to check if a comment has children
  def has_children?
    self.children.any?
  end

  # Helper class method to lookup all comments assigned
  # to all commentable types for a given user.
  scope :find_comments_by_user, lambda { |user|
    where(:user_id => user.id).order('created_at DESC')
  }

  # Helper class method to look up all comments for
  # commentable class name and commentable id.
  scope :find_comments_for_commentable, lambda { |commentable_str, commentable_id|
    where(:commentable_type => commentable_str.to_s, :commentable_id => commentable_id).order('created_at DESC')
  }

  # Helper class method to look up all comments for
  # commentable class name and commentable id except current_user
  scope :find_comments_for_commentable_without_current, lambda { |commentable_str, commentable_id|
    where(:commentable_type => commentable_str.to_s, :commentable_id => commentable_id).order('created_at DESC').not(user_id: current_user.id)
  }

  # Helper class method to look up a commentable object
  # given the commentable class name and id
  def self.find_commentable(commentable_str, commentable_id)
    commentable_str.constantize.find(commentable_id)
  end

  def can_score?
    true
  end

  #Get commentable user
  def commentable_user
    commentable.user
  end

  private

  def create_activity
    CreateActivityJob.perform_later(id, self.class.to_s) if Activity.where(trackable: self).empty?
  end

  def update_counters
    #Update comments counter for commentable
    commentable.comments_counter.reset
    commentable.comments_counter.incr(commentable.comments.size)
    user.comments_counter.reset
    user.comments_counter.incr(user.comments.size)
  end

  def cache_commenters_ids
    #cache commenters ids
    commentable.commenters_ids << user_id unless commentable.commented?(user)
  end

  def deleted_cached_commenters_ids
    #cache commenters ids
    commentable.commenters_ids.delete(user_id) if commentable.commented?(user)
  end

  def delete_notification
    #Delete activity item from feed
    DeleteActivityJob.perform_later(self.id, self.class.to_s)
  end

end
