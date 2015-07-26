class RecordSavedJob < ActiveJob::Base

  def perform(id, type)
    ActiveRecord::Base.connection_pool.with_connection do
      if type.constantize.find(id).present?
        @record = type.constantize.find(id)
        "#{type}SavedService".constantize.new(@record).call
      else
        return false
      end
    end
  end

end