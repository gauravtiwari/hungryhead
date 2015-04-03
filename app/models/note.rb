class Note < ActiveRecord::Base
  belongs_to :notable, polymorphic: true, counter_cache: true
  belongs_to :user
  enum status: {created: 0, trashed: 1, deleted: 2}
  store_accessor :parameters, :body
end
