class UnreadMigration < ActiveRecord::Migration
  disable_ddl_transaction!
  def self.up
    create_table :read_marks, force: true do |t|
      t.references :readable, polymorphic: { null: false }
      t.references :user,     null: false
      t.datetime :timestamp
    end

    add_index :read_marks, [:user_id, :readable_type, :readable_id], algorithm: :concurrently
  end

  def self.down
    drop_table :read_marks
  end
end
