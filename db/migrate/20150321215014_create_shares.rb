class CreateShares < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    create_table :shares do |t|
      t.text :body, null: false, default: ""
      t.text :link, null: false, default: ""
      t.uuid :uuid, null: false, default: 'uuid_generate_v4()'
      t.references :owner, polymorphic: true, null: false
      t.timestamps null: false
    end
    add_index :shares, :owner_id, algorithm: :concurrently
  end
end