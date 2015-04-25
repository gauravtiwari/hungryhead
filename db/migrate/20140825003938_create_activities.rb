# Migration responsible for creating a table with activities
class CreateActivities < ActiveRecord::Migration
  # Create table
  def self.up
    create_table :activities do |t|
      t.belongs_to :trackable, :polymorphic => true
      t.belongs_to :owner, :polymorphic => true
      t.string  :key
      t.string :type
      t.jsonb    :parameters
      t.boolean :published, :boolean, default: true
      t.belongs_to :recipient, :polymorphic => true
      t.timestamps null: false
    end

    add_index :activities, [:trackable_id, :trackable_type]
    add_index :activities, [:owner_id, :owner_type, :key]
    add_index :activities, [:recipient_id, :recipient_type]
    add_index :activities, [:published]
  end
  # Drop table
  def self.down
    drop_table :activities
  end
end
