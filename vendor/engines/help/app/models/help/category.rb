module Help
  class Category < ActiveRecord::Base
    acts_as_copy_target
    extend FriendlyId
    friendly_id :name, use: :slugged
    has_many :articles

    after_commit :backup_to_file

    private

    def backup_to_file
      Help::Category.copy_to "#{Rails.root}/db/seeds/backups/help/categories.csv"
    end

  end
end
