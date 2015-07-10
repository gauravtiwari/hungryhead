class IdeaMessage < ActiveRecord::Base
  #Associations
  belongs_to :user
  belongs_to :idea, touch: true

  after_commit :update_counters, on: [:create, :destroy]
  before_destroy :decrement_counter

  private

  def update_counters
    idea.idea_messages_counter.incr(idea.idea_messages.size)
  end

end
