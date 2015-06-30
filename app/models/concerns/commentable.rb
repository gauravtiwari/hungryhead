module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, as: :commentable, :dependent => :destroy
    cache_has_many :comments, inverse_name: :commentable, embed: true
  end

  def root_comments
    self.fetch_comments.select{|c| c.parent_id == nil }
  end

  def comment_threads
    self.fetch_comments
  end

  def get_commenters
    User.fetch_multi(commenters_ids)
  end

  def commenter
    commentable.user_id
  end

end