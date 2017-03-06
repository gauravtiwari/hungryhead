class HelpBackupRestoreService
  def backup
    Help::Article.copy_to "#{Rails.root}/db/seeds/backups/help/articles.csv"
    Help::Category.copy_to "#{Rails.root}/db/seeds/backups/help/categories.csv"
  end

  def restore
    Help::Article.copy_from "#{Rails.root}/db/seeds/backups/help/articles.csv"
    Help::Category.copy_from "#{Rails.root}/db/seeds/backups/help/categories.csv"
  end
end
