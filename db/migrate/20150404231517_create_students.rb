class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.jsonb  :education, :default => "{}"
      t.string :cached_hobbies_list
      t.integer :ideas_count, default: 0
      t.timestamps null: false
    end
    add_index :students, :education, using: :gin
  end
end
