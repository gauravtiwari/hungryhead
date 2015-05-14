class AddFieldsToUsers < ActiveRecord::Migration
  disable_ddl_transaction!
  def self.up
    add_column :users, :sash_id, :integer
    add_column :users, :level, :integer, :default => 0
    add_index :users, :sash_id, algorithm: :concurrently
    add_index :users, :level, algorithm: :concurrently
  end

  def self.down
    remove_column :users, :sash_id
    remove_column :users, :level
  end
end
