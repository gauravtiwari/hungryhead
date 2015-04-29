class CreateFeedbacks < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    create_table :feedbacks do |t|
      t.text :body, :null => false
      t.integer :idea_id, :null => false
      t.integer :user_id, :null => false
      t.integer :status, default: 0, null: false
      t.jsonb :parameters, default: "{}"

      #Score to calculate popularity
      t.bigint :score, default: DateTime.now.to_i

      #Caching ids
      t.string :voters_ids, array: true, default: "{}"
      t.string :commenters_ids, array: true, default: "{}"
      t.string :sharer_ids, array: true, default: "{}"

      t.integer :votes_count, null: false, default: 0
      t.integer :comments_count, null: false, default: 0
      t.integer :shares_count, null: false, default: 0

      t.timestamps null: false
    end
    add_index :feedbacks, :user_id, algorithm: :concurrently
    add_index :feedbacks, :score, algorithm: :concurrently
    add_index :feedbacks, :parameters, using: :gin
    add_index :feedbacks, :idea_id, algorithm: :concurrently
  end
end
