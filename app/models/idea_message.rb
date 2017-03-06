class IdeaMessage < ActiveRecord::Base
  # Associations
  belongs_to :user
  belongs_to :idea, touch: true

  # Callbacks
  after_commit :update_counters, on: [:create, :destroy]

  private

  # Update counters
  def update_counters
    idea.idea_messages_counter.incr(idea.idea_messages.size)
    true
  end
end
