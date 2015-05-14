module Commenter
  extend ActiveSupport::Concern

  included do
    has_many :comments, :dependent => :destroy
  end

  def root_comments
    self.comments.where(:parent_id => nil)
  end

  def comment_threads
    self.comments
  end

  def comments_score
    comments.inject(0){ |sum, comment| sum + comment.votes_counter.value }
  end

end