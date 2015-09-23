class IdeaMessage < ActiveRecord::Base

  #Associations
  belongs_to :user, -> {with_deleted}
  belongs_to :idea, -> {with_deleted}, touch: true

  after_commit :update_counters, on: [:create, :destroy]

  private

  def update_counters
    idea.idea_messages_counter.incr(idea.idea_messages.size)
    true
  end
end
