class UpdateUserScoreJob < ActiveJob::Base
  def perform
    ActiveRecord::Base.connection_pool.with_connection do
      User.where(admin: false).find_each do |user|
        User.leaderboard[user.id] = user.points
      end
    end
  end
end
