module Commentable

  extend ActiveSupport::Concern

  included do
    has_many :comments, as: :commentable, :dependent => :destroy
  end

  # Methods to fetch comments: root and top level
  def root_comments
    comments.where(parent_id: nil).order(created_at: :desc)
  end

  def comment_threads
    comments.order(created_at: :desc)
  end

  def commented?(user)
    commenters_ids.include?(user.id.to_s)
  end

  def get_commenters
    User.find(commenters_ids)
  end

  def commenter
    commentable.user_id
  end

end