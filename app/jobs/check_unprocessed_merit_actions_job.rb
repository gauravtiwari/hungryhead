class CheckUnprocessedMeritActionsJob < ActiveJob::Base
  def perform
    ActiveRecord::Base.connection_pool.with_connection do
      Merit::Action.check_unprocessed = true
    end
  end
end
