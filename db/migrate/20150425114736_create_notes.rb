class CreateNotes < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    create_table :notes do |t|
      t.string :title
      t.text :body
      t.integer :status
      t.belongs_to :user, index: true, foreign_key: true
      t.integer :votes_count, null: false, default: 0
      t.integer :comments_count, null: false, default: 0
      t.integer :shares_count, null: false, default: 0
      t.timestamps null: false
    end
    add_index :notes, [:status, :user_id], algorithm: :concurrently
  end
end
