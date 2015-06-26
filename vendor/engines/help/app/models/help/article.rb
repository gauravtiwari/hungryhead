module Help
  class Article < ActiveRecord::Base
    scope :published, -> { where(published: true) }
    extend FriendlyId
    friendly_id :title, use: :slugged
    belongs_to :category, touch: true
  end
end
