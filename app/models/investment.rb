class Investment < ActiveRecord::Base

  include IdentityCache

  #Associations
  belongs_to :user, touch: true
  counter_culture :user
  belongs_to :idea, touch: true
  counter_culture :idea

  #Includes concerns
  include Commentable
  include Votable

  #Store accessor methods
  store_accessor :parameters, :point_earned, :views_count

  #Includes modules
  has_merit

  #Caching Model
  cache_has_many :votes, :inverse_name => :votable, :embed => true
  cache_has_many :comments, :inverse_name => :commentable, embed: true

  #Model Callbacks
	before_destroy :cancel_investment, :remove_cache_ids, :delete_activity
  after_commit :cache_ids, on: :create

  public

  def can_score?
    false
  end

	private

  def cancel_investment
    idea.update_attributes(fund: {"balance" => idea.balance - amount })
    user.update_attributes(fund: {"balance" => user.balance + amount })
  end

  def cache_ids
    idea.investors.push(user.id)
    idea.score + 1
    user.score + 1
    save_cache
  end

  def remove_cache_ids
    idea.investors.delete(user.id.to_s)
    idea.score - 1
    user.score - 1
    save_cache
  end

  def save_cache
    idea.save
    user.save
  end

  def delete_activity
    DeleteUserFeedJob.perform_later(self.id, self.class.to_s)
  end

end
