# Migration responsible for creating a table with activities
class CreateActivities < ActiveRecord::Migration
  # Create table
  def self.up
    create_table :activities do |t|
      t.belongs_to :trackable, :polymorphic => true
      t.belongs_to :user
      t.string  :key
      t.string :type, default: 'Activity'
      t.jsonb    :parameters
      t.boolean :published, default: true
      t.belongs_to :recipient, :polymorphic => true
      t.timestamps null: false
    end

    add_index :activities, [:trackable_id, :trackable_type]
    add_index :activities, [:key, :published, :type]
    add_index :activities, [:recipient_id, :recipient_type]
  end
  # Drop table
  def self.down
    drop_table :activities
  end
end
