class RecordChangeListener

  def record_created(record)
    "#{record.class.to_s}CreatedService".constantize.new(record).call
  end

  def record_saved(record)
    "#{record.class.to_s}SavedService".constantize.new(record).call
  end


end