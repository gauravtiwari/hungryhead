class CreateIdeaMessages < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    create_table :idea_messages do |t|
      t.integer :student_id, :null => false
      t.integer :idea_id, :null => false
      t.text :body, :null => false
      t.integer :status
      t.timestamps null: false
    end
    add_index :idea_messages, :idea_id, algorithm: :concurrently
    add_index :idea_messages, :student_id, algorithm: :concurrently
  end
end
