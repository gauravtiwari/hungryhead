module Help
  class Article < ActiveRecord::Base
    acts_as_copy_target
    scope :published, -> { where(published: true) }
    extend FriendlyId
    friendly_id :title, use: :slugged
    belongs_to :category, touch: true

    after_commit :backup_to_file

    private

    def backup_to_file
      Help::Article.copy_to "#{Rails.root}/db/seeds/backups/help/articles.csv"
    end
  end
end
