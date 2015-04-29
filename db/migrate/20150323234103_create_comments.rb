class CreateComments < ActiveRecord::Migration
  disable_ddl_transaction!
  def self.up
    create_table :comments, :force => true do |t|
      t.integer :commentable_id
      t.string :commentable_type
      t.string :title
      t.text :body
      t.string :subject
      t.integer :user_id, :null => false
      t.integer :parent_id, :lft, :rgt

      #Score to calculate popularity
      t.bigint :score, default: DateTime.now.to_i

      t.string :role, :default => "comments"

      #Caching ids
      t.string :voters_ids, array: true, default: "{}"

      t.integer :votes_count, null: false, default: 0
      t.timestamps
    end

    add_index :comments, :user_id, algorithm: :concurrently
    add_index :comments, :score, algorithm: :concurrently
    add_index :comments, [:commentable_id, :commentable_type], algorithm: :concurrently
  end

  def self.down
    drop_table :comments
  end
end
