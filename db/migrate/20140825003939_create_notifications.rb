# Migration responsible for creating a table with notifications
class CreateNotifications < ActiveRecord::Migration
  disable_ddl_transaction!
  # Create table
  def self.up
    create_table :notifications do |t|
      t.belongs_to :trackable, :polymorphic => true
      t.belongs_to :user
      t.string  :key
      t.jsonb    :parameters, default: "{}"
      t.boolean :published, default: true, index: true
      t.belongs_to :recipient, :polymorphic => true
      t.timestamps null: false
    end

    add_index :notifications, [:trackable_id, :trackable_type], algorithm: :concurrently
    add_index :notifications, [:key], algorithm: :concurrently
    add_index :notifications, [:recipient_id, :recipient_type], algorithm: :concurrently
  end
  # Drop table
  def self.down
    drop_table :notifications
  end
end
