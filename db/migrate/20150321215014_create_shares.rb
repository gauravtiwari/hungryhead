class CreateShares < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    create_table :shares do |t|
      t.text :body, null: false, default: ""
      t.text :link, null: false, default: ""
      t.uuid :uuid, null: false, default: 'uuid_generate_v4()'
      t.references :user, polymorphic: true, null: false
      t.timestamps null: false
    end
    add_index :shares, [:user_id, :user_type], algorithm: :concurrently
  end
end