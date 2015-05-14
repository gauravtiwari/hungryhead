class AddFieldsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :sash_id, :integer
    add_column :posts, :level,   :integer, :default => 0
    add_index :posts, :sash_id
    add_index :posts, :level
  end
end
