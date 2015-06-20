class Impression < ActiveRecord::Base

  belongs_to :user
  belongs_to :impressionable, polymorphic: true
  after_create :increment_counter

  private

  def increment_counter
    impressioners_ids.add(user_id)
  end

end
