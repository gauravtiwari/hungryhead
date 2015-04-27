class CreateFollows < ActiveRecord::Migration
  disable_ddl_transaction!
  def up
    create_table :follows do |t|
      t.references :followable, polymorphic: true
      t.references :follower, polymorphic: true
      t.timestamps null: false
    end

    add_index :follows, ['follower_id', 'follower_type'],     name: 'index_followers', algorithm: :concurrently
    add_index :follows, ['followable_id', 'followable_type'], name: 'index_followables', algorithm: :concurrently
  end

  def down
    drop_table :follows
  end
end
