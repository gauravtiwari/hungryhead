class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.references :notable, polymorphic: true
      t.jsonb :parameters
      t.integer :status
      t.references :user, index: true, foreign_key: true
      t.timestamps null: false
    end
    add_index :notes, :notable_id
    add_index :notes, :notable_type
    add_index :notes, :status
  end
end
