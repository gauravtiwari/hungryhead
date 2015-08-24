class DestroyRecordJob < ActiveJob::Base
  def perform(record)
   ActiveRecord::Base.connection_pool.with_connection do
   		record.really_destroy!
	 end
  end
end
