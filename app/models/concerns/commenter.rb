module Commenter
  extend ActiveSupport::Concern

  included do
    has_many :comments, :dependent => :destroy
    cache_has_many :comments, embed: true
  end

  def comments_score
    fetch_comments.inject(0){ |sum, comment| sum + comment.votes_counter.value }
  end
end