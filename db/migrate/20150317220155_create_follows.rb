class CreateFollows < ActiveRecord::Migration
  disable_ddl_transaction!
  def up
    create_table :follows do |t|
      t.references :followable, polymorphic: true, null: false
      t.integer :follower_id, class_name: 'User', foreign_key: true, null: false
      t.timestamps null: false
    end

    add_index :follows, :follower_id, algorithm: :concurrently
    add_index :follows, [:followable_id, :followable_type, :follower_id], unique: true, name: 'unique_follows_index', algorithm: :concurrently
  end

  def down
    drop_table :follows
  end
end
