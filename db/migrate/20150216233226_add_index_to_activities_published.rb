class AddIndexToActivitiesPublished < ActiveRecord::Migration
  def change
  	add_index :activities, :published
  end
end
