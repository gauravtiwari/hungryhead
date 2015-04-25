module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, as: :commentable, :dependent => :destroy
  end

  module ClassMethods
    def root_comments
      self.comments.where(:parent_id => nil)
    end

    def comment_threads
      self.comments
    end
  end

end