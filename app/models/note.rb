class Note < ActiveRecord::Base
  belongs_to :user
  has_many :comments, as: :commentable, :dependent => :destroy
  has_many :votes, as: :votable, :dependent => :destroy
  has_many :shares, as: :shareable, dependent: :destroy, autosave: true
end
