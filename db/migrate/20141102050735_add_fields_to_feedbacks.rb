class AddFieldsToFeedbacks < ActiveRecord::Migration
  def self.up
    add_column :feedbacks, :sash_id, :integer, index: true
    add_column :feedbacks, :level, :integer, :default => 0, index: true
  end

  def self.down
    remove_column :feedbacks, :sash_id
    remove_column :feedbacks, :level
  end
end
