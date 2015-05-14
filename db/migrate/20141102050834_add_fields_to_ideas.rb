class AddFieldsToIdeas < ActiveRecord::Migration
  def self.up
    add_column :ideas, :sash_id, :integer, index: true
    add_column :ideas, :level, :integer, :default => 0, index: true
  end

  def self.down
    remove_column :ideas, :sash_id
    remove_column :ideas, :level
  end
end
