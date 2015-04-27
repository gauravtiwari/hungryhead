# Migration responsible for creating a table with activities
class CreateNotifications < ActiveRecord::Migration
  # Create table
  def self.up
    create_table :notifications do |t|
      t.belongs_to :trackable, :polymorphic => true, unique: true
      t.belongs_to :user
      t.string  :key, unique: true
      t.jsonb    :parameters, default: "{}"
      t.boolean :published, default: true
      t.belongs_to :recipient, :polymorphic => true
      t.timestamps null: false
    end

    add_index :notifications, [:trackable_id, :trackable_type]
    add_index :notifications, [:key, :published]
    add_index :notifications, [:recipient_id, :recipient_type]
  end
  # Drop table
  def self.down
    drop_table :notifications
  end
end
