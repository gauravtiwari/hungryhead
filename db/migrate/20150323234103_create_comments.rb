class CreateComments < ActiveRecord::Migration
  disable_ddl_transaction!

  def self.up
    create_table :comments, :force => true do |t|

      t.references :commentable, polymorphic: true, null: false

      t.text :body, null: false, default: ""

      t.references :user, :null => false
      t.integer :parent_id, :null => true, :index => true
      t.integer :lft, :null => false, :index => true
      t.integer :rgt, :null => false, :index => true
      t.integer :depth, :null => false, :default => 0
      t.integer :children_count, :null => false, :default => 0

      t.timestamps

    end

    add_index :comments, :user_id, algorithm: :concurrently
    add_index :comments, [:commentable_id, :commentable_type], algorithm: :concurrently
    add_index :comments, [:user_id, :commentable_id, :commentable_type], name: 'user_commentable_comments', algorithm: :concurrently
  end

  def self.down
    drop_table :comments
  end

end
