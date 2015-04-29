# Migration responsible for creating a table with activities
class CreateActivities < ActiveRecord::Migration
  disable_ddl_transaction!
  # Create table
  def self.up
    create_table :activities do |t|
      t.belongs_to :trackable, :polymorphic => true

      t.belongs_to :user

      t.string  :key
      t.jsonb    :parameters, default: "{}"

      t.boolean :published, default: true

      t.belongs_to :recipient, :polymorphic => true

      t.timestamps null: false
    end

    add_index :activities, [:trackable_id, :trackable_type], algorithm: :concurrently
    add_index :activities, [:published], algorithm: :concurrently
    add_index :activities, [:recipient_id, :recipient_type], algorithm: :concurrently
  end
  # Drop table
  def self.down
    drop_table :activities
  end
end
