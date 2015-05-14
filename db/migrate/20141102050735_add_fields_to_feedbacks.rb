class AddFieldsToFeedbacks < ActiveRecord::Migration
  disable_ddl_transaction!
  def self.up
    add_column :feedbacks, :sash_id, :integer
    add_column :feedbacks, :level, :integer, :default => 0
    add_index :feedbacks, :sash_id, algorithm: :concurrently
    add_index :feedbacks, :level, algorithm: :concurrently
  end

  def self.down
    remove_column :feedbacks, :sash_id
    remove_column :feedbacks, :level
  end
end
