# Migration responsible for creating a table with activities
class CreateActivities < ActiveRecord::Migration

  disable_ddl_transaction!
  # Create table
  def self.up

    create_table :activities do |t|

      t.belongs_to :trackable, :polymorphic => true , null: false

      t.belongs_to :owner, polymorphic: true, null: false

      t.string  :key , null: false, default: ""

      t.jsonb :parameters, default: "{}"

      t.uuid :uuid, null: false, default: 'uuid_generate_v4()'

      t.boolean :published, default: true

      t.boolean :is_notification, default: false

      t.belongs_to :recipient, :polymorphic => true, null: false

      t.timestamps null: false
    end

    add_index :activities, [:trackable_id, :trackable_type], algorithm: :concurrently
    add_index :activities, [:owner_id, :owner_type, :published, :is_notification], name: 'owner_published_activities', algorithm: :concurrently
    add_index :activities, [:owner_id, :owner_type, :trackable_id, :trackable_type, :key], unique: true, name: 'unique_activity_per_owner'
    add_index :activities, :uuid, algorithm: :concurrently
    add_index :activities, [:recipient_id, :recipient_type, :published, :is_notification], name: 'recipient_published_activities', algorithm: :concurrently
  end

  # Drop table
  def self.down
    drop_table :activities
  end

end
