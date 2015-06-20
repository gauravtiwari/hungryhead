class IdeaMessage < ActiveRecord::Base
  #Associations
  belongs_to :user, touch: true
  belongs_to :idea

  after_create :increment_counter
  before_destroy :decrement_counter

  private

  def increment_counter
    idea.idea_messages_counter.increment
  end

  def increment_counter
    idea.idea_messages_counter.decrement
  end

end
