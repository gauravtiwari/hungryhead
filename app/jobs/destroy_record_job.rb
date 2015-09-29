class DestroyRecordJob < ActiveJob::Base
  def perform(record)
   ActiveRecord::Base.connection_pool.with_connection do
   		record.destroy!
	 end
  end
end
