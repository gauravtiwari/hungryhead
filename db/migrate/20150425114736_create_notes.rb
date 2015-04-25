class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :title
      t.text :body
      t.integer :status
      t.belongs_to :user, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :notes, :status
  end
end
