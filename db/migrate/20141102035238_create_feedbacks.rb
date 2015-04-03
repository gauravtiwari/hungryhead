class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.text :body, :null => false
      t.integer :idea_id, :null => false
      t.integer :user_id, :null => false
      t.integer :status, default: 0, null: false
      t.integer :comments_count,default: 0, index: true
      t.integer :cached_votes_total, default: 0, index: true
      t.jsonb :parameters, default: "{}"
      t.timestamps null: false
    end
    add_index :feedbacks, :user_id
    add_index :feedbacks, :parameters, using: :gin
    add_index :feedbacks, :idea_id
  end
end
