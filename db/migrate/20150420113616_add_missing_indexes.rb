class AddMissingIndexes < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    add_index :slugs, [:sluggable_id, :sluggable_type], algorithm: :concurrently
    add_index :taggings, [:tag_id], algorithm: :concurrently
    add_index :follows, [:followable_id, :followable_type], algorithm: :concurrently
  end
end