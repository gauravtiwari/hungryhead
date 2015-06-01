# Migration responsible for creating a table with activities
class CreateActivities < ActiveRecord::Migration
  disable_ddl_transaction!

  # Create table

  def self.up

    create_table :activities do |t|

      t.belongs_to :trackable, :polymorphic => true , null: false

      t.belongs_to :user, null: false

      t.string  :key , null: false, default: ""

      t.jsonb :parameters, default: "{}"

      t.uuid :uuid, null: false, default: 'uuid_generate_v4()'

      t.boolean :published, default: true

      t.belongs_to :recipient, :polymorphic => true, null: false

      t.timestamps null: false
    end

    add_index :activities, [:trackable_id, :trackable_type], algorithm: :concurrently
    add_index :activities, [:published], algorithm: :concurrently
    add_index :activities, :uuid, algorithm: :concurrently
    add_index :activities, [:recipient_id, :recipient_type], algorithm: :concurrently
  end

  # Drop table
  def self.down
    drop_table :activities
  end

end
