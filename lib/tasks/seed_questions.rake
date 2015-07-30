#Load questions into DB

namespace :db do
  desc "Load questions into database"
  task :seed_questions => :environment do
    HelpBackupRestoreService.new().restore
  end
end