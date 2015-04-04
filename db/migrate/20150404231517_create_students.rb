class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.integer :ideas_count, default: 0
      t.timestamps null: false
    end
  end
end
