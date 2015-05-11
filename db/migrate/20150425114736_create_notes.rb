class CreateNotes < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    create_table :notes do |t|

      t.string :title, null: false, default: ""
      t.text :body, null: false, default: ""

      t.integer :score, null: false, default: 0
      t.integer :views, null: false, default: 0

      t.string :slug, null: false, default: ""

      t.integer :status
      t.belongs_to :user, foreign_key: true, null: false

      t.timestamps null: false
    end
    add_index :notes, :status, algorithm: :concurrently
    add_index :notes, :rank, algorithm: :concurrently
    add_index :notes, :user_id, algorithm: :concurrently
    add_index :notes, :slug, unique: true, algorithm: :concurrently
  end
end
