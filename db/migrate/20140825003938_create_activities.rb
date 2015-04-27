# Migration responsible for creating a table with activities
class CreateActivities < ActiveRecord::Migration
  # Create table
  def self.up
    create_table :activities do |t|
      t.belongs_to :trackable, :polymorphic => true
      t.belongs_to :user
      t.string  :key
      t.jsonb    :parameters, default: "{}"
      t.boolean :published, default: true, index: true
      t.belongs_to :recipient, :polymorphic => true
      t.timestamps null: false
    end

    add_index :activities, [:trackable_id, :trackable_type], unique: true
    add_index :activities, [:key], unique: true
    add_index :activities, [:recipient_id, :recipient_type]
  end
  # Drop table
  def self.down
    drop_table :activities
  end
end
