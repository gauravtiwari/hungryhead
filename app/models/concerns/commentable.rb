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
    User.where(id: commenters_ids)
  end

  def commenter
    commentable_type == "Idea" ? commentable.student.id : commentable.user.id
  end

end