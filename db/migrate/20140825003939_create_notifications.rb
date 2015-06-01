# Migration responsible for creating a table with notifications
class CreateNotifications < ActiveRecord::Migration
  disable_ddl_transaction!
  # Create table
  def self.up
    create_table :notifications do |t|

      t.belongs_to :trackable, :polymorphic => true , null: false

      t.belongs_to :user, null: false

      t.integer :parent_id, default: nil

      t.string  :key, null: false, default: ""

      t.jsonb    :parameters, default: "{}"

      t.boolean :published, default: true

      t.belongs_to :recipient, :polymorphic => true , null: false

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
