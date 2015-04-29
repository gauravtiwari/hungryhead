class Note < ActiveRecord::Base

  #Includes Modules
  include IdentityCache

  belongs_to :user
  counter_culture :note #counter cache

  #Includes concerns
  include Commentable
  include Shareable
  include Votable

  #Caching Model
  cache_has_many :votes, :inverse_name => :votable, :embed => true
  cache_has_many :comments, :inverse_name => :commentable, embed: true
  cache_has_many :shares, :inverse_name => :shareable, embed: true

  #Model callbacks
  before_destroy :delete_activity, :substract_score
  after_commit :add_score, on: :create

  public

  def can_score?
    true
  end

  private

  def delete_activity
    DeleteUserFeedJob.perform_later(self.id, self.class.to_s)
  end

  def add_score
    user.score + 1
    user.save
  end

  def substract_score
    user.score - 1
    user.save
  end

end
