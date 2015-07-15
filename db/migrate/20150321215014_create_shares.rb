class CreateShares < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    create_table :shares do |t|
      t.text :body, null: false, default: ""
      t.text :link, null: false, default: ""
      t.references :shareable, polymorphic: true, null: false
      t.references :owner, polymorphic: true, null: false
      t.timestamps null: false
    end

    add_index :shares, [:shareable_id, :shareable_type], algorithm: :concurrently
    add_index :shares, [:owner_id, :shareable_id, :shareable_type], unique: true, algorithm: :concurrently
  end
end