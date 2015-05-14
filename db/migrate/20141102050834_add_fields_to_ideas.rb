class AddFieldsToIdeas < ActiveRecord::Migration
  disable_ddl_transaction!
  def self.up
    add_column :ideas, :sash_id, :integer
    add_column :ideas, :level, :integer, :default => 0
    add_index :ideas, :sash_id, algorithm: :concurrently
    add_index :ideas, :level, algorithm: :concurrently
  end

  def self.down
    remove_column :ideas, :sash_id
    remove_column :ideas, :level
  end
end
