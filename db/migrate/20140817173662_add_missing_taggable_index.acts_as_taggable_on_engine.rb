# This migration comes from acts_as_taggable_on_engine (originally 4)
class AddMissingTaggableIndex < ActiveRecord::Migration
  disable_ddl_transaction!
  def self.up
    add_index :taggings, [:taggable_id, :taggable_type, :context], algorithm: :concurrently
  end

  def self.down
    remove_index :taggings, [:taggable_id, :taggable_type, :context]
  end
end
