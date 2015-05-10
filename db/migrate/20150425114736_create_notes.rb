class CreateNotes < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    create_table :notes do |t|
      t.string :title
      t.text :body
      t.string :slug
      t.integer :status
      t.belongs_to :user, foreign_key: true

      t.timestamps null: false
    end
    add_index :notes, :status, algorithm: :concurrently
    add_index :notes, :user_id, algorithm: :concurrently
    add_index :notes, :slug, unique: true, algorithm: :concurrently
  end
end
