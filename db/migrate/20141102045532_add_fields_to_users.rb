class AddFieldsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :sash_id, :integer, index: true
    add_column :users, :level, :integer, :default => 0, index: true
  end

  def self.down
    remove_column :users, :sash_id
    remove_column :users, :level
  end
end
