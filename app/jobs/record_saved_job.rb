class RecordSavedJob < ActiveJob::Base
  def perform(id, type)
    ActiveRecord::Base.connection_pool.with_connection do
      if type.constantize.where(id: id).empty?
        return false
      else
        @record = type.constantize.find(id)
        "#{type}SavedService".constantize.new(@record).call
      end
    end
  end
end
