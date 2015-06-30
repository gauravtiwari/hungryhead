module Commenter
  extend ActiveSupport::Concern

  included do
    has_many :comments, :dependent => :destroy
  end

  def comments_score
    comments.inject(0){ |sum, comment| sum + comment.votes_counter.value }
  end
end