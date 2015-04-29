class Feedback < ActiveRecord::Base

  include IdentityCache
  #Includes concerns
  include Commentable
  include Shareable
  include Votable

  has_merit

  #Associations
  belongs_to :idea, touch: true
  counter_culture :idea
  belongs_to :user, touch: true
  counter_culture :user

  #Enums and states
  enum status: { posted:0, badged:1, flagged:2 }

  store_accessor :parameters, :point_earned, :views_count

  #Caching Model
  cache_has_many :votes, :inverse_name => :votable, :embed => true
  cache_has_many :comments, :inverse_name => :commentable, embed: true

  #Hooks
  before_destroy :remove_cache_ids, :delete_activity
  after_commit :cache_ids, on: :create

  public

  def can_score?
    true
  end

  private

  def cache_ids
    idea.feedbackers_ids.push(user.id)
    idea.score + 1
    user.score + 1
    save_cache
  end

  def remove_cache_ids
    idea.feedbackers.delete(user.id.to_s)
    idea.score - 1
    user.score - 1
    save_cache
  end

  def save_cache
    user.save
    idea.save
  end

  def delete_activity
    DeleteUserFeedJob.perform_later(self.id, self.class.to_s)
  end

end
