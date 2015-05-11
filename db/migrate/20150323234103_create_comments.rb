class CreateComments < ActiveRecord::Migration
  disable_ddl_transaction!
  def self.up
    create_table :comments, :force => true do |t|

      t.references :commentable, polymorphic: true, null: false
      t.text :body, null: false, default: ""

      t.integer :score, null: false, default: 0

      t.references :user, :null => false
      t.integer :parent_id, :lft, :rgt

      t.timestamps

    end

    add_index :comments, :user_id, algorithm: :concurrently
    add_index :comments, :rank, algorithm: :concurrently
    add_index :comments, :parent_id, algorithm: :concurrently
    add_index :comments, [:commentable_id, :commentable_type], algorithm: :concurrently
  end

  def self.down
    drop_table :comments
  end
end
