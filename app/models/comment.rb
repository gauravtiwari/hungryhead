class Comment < ActiveRecord::Base

  include IdentityCache

  acts_as_nested_set :scope => [:commentable_id, :commentable_type]

  validates :body, :presence => true
  validates :user, :presence => true

  include Votable
  include Mentioner

  after_commit :cache_ids, :update_activity_score, on: :create
  before_destroy :remove_cache_ids, :delete_activity

  #Model Associations
  belongs_to :user
  counter_culture :user
  belongs_to :commentable, :polymorphic => true, touch: true
  counter_culture :commentable

  #Caching Model
  cache_has_many :votes, :inverse_name => :votable, :embed => true

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

  private

  def cache_ids
    commentable.commenters_ids.push(user_id)
    commentable.score + 1 if commentable.can_score?
    user.score + 1
    save_cache
  end

  def remove_cache_ids
    commentable.commenters_ids.delete(user_id.to_s)
    commentable.score - 1 if commentable.can_score?
    user.score - 1
    save_cache
  end

  def update_activity_score
    @activity = Activity.find_by_recipient_id_and_recipient_type(commentable)
    @activity.score = score + 1
    @activity.save
  end

  def save_cache
    commentable.save
    user.save
  end

  def delete_activity
    DeleteUserNotificationJob.perform_later(self.id, self.class.to_s)
  end

end
