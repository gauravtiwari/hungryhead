class CreateFeedbacks < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    create_table :feedbacks do |t|
      t.text :body, :null => false
      t.integer :idea_id, :null => false
      t.integer :user_id, :null => false
      t.integer :status, default: 0, null: false
      t.jsonb :parameters, default: "{}"
      t.timestamps null: false
    end
    add_index :feedbacks, :user_id, algorithm: :concurrently
    add_index :feedbacks, :parameters, using: :gin
    add_index :feedbacks, :idea_id, algorithm: :concurrently
  end
end
