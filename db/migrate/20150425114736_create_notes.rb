class CreateNotes < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    create_table :notes do |t|
      t.string :title
      t.text :body
      t.integer :status
      t.belongs_to :user, index: true, foreign_key: true

      #Score to calculate popularity
      t.bigint :score, default: DateTime.now.to_i

      #Caching ids
      t.string :voters_ids, array: true, default: "{}"
      t.string :commenters_ids, array: true, default: "{}"
      t.string :sharers_ids, array: true, default: "{}"

      t.integer :votes_count, null: false, default: 0
      t.integer :comments_count, null: false, default: 0
      t.integer :shares_count, null: false, default: 0

      t.timestamps null: false
    end
    add_index :notes, :status, :user_id], algorithm: :concurrently
    add_index :notes, :user_id, algorithm: :concurrently
    add_index :notes, :score, algorithm: :concurrently
  end
end
