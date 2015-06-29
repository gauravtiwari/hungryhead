module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, as: :commentable, :dependent => :destroy
  end

  def root_comments
    self.comments.where(:parent_id => nil)
  end

  def comment_threads
    self.comments
  end

  def get_commenters
    User.fetch_multi(commenters_ids)
  end

  def commenter
    commentable.user_id
  end

end