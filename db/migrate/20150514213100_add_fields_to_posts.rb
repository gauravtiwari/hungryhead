class AddFieldsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :sash_id, :integer
    add_column :posts, :level,   :integer, :default => 0
  end
end
