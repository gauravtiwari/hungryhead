class Comment < ActiveRecord::Base

  include Redis::Objects

  acts_as_nested_set :scope => [:commentable_id, :commentable_type]

  validates :body, :presence => true
  validates :user, :presence => true

  include Votable
  include Mentioner

  #Redis counters and ids cache
  counter :votes_counter
  list :voters_ids

  after_commit :increment_counters, :create_notification, :award_badge, on: :create
  before_destroy :decrement_counters, :delete_notification

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

  private

  def increment_counters
    #Increment counters for commentable
    commentable.comments_counter.increment
    #Increment popularity score
    Idea.popular.increment(commentable_id) if commentable_type == "Idea"
    User.popular.increment(user_id)
    #Cache commenter id
    commentable.commenters_ids << user_id
  end

  def award_badge
    #Award badge if published 30 comments
    AwardBadgeJob.set(wait: 5.seconds).perform_later(user.id, 4, "Comment_#{id}") if user.comments_30?
  end

  def create_notification
    #Enque activity creation
    CreateActivityJob.set(wait: 2.seconds).perform_later(self.id, self.class.to_s)
  end

  def decrement_counters
    #Decrement comments counter
    commentable.comments_counter.decrement if commentable.comments_counter.value > 0
    #Decrement popularity score
    Idea.popular.decrement(commentable_id) if commentable_type == "Idea"
    User.popular.decrement(user_id)
    #delete cached commenter id
    commentable.commenters_ids.delete(user_id)
  end

  def delete_notification
    #Delete activity item from feed
    DeleteUserNotificationJob.set(wait: 5.seconds).perform_later(self.id, self.class.to_s)
  end

end
