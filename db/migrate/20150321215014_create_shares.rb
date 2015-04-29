class CreateShares < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    create_table :shares do |t|
      t.text :body
      t.integer :status
      t.integer :privacy
      t.references :shareable, polymorphic: true
      t.references :user, foreign_key: true
      t.jsonb :parameters
      t.integer :votes_count, null: false, default: 0
      t.integer :comments_count, null: false, default: 0
      t.timestamps null: false
    end
    add_index :shares, [:shareable_id, :shareable_type], algorithm: :concurrently
    add_index :shares, [:user_id], algorithm: :concurrently
  end
end
