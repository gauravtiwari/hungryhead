class CreateShares < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    create_table :shares do |t|

      t.uuid :uuid, null: false, default: 'uuid_generate_v4()'

      t.text :body, null: false, default: ""

      t.integer :status
      t.integer :privacy

      t.references :shareable, polymorphic: true, null: false
      t.references :user, foreign_key: true, null: false

      t.jsonb :parameters
      t.timestamps null: false

    end

    add_index :shares, [:shareable_id, :shareable_type], algorithm: :concurrently
    add_index :shares, [:user_id], algorithm: :concurrently

  end
end
