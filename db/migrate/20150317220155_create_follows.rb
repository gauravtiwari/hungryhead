class CreateFollows < ActiveRecord::Migration
  disable_ddl_transaction!
  def up
    create_table :follows do |t|
      t.references :followable, polymorphic: true, null: false
      t.references :follower, polymorphic: true, null: false
      t.timestamps null: false
    end
  end

  def down
    drop_table :follows
  end
end
