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

  def comments_50?
    comments_counter.value == 30
  end

  def comments_100?
    comments_counter.value == 100
  end

end