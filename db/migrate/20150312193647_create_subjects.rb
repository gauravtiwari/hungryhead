class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.string :name
      t.text :description
      t.string :slug
      t.timestamps null: false
    end
    add_index :subjects, :slug, unique: true
  end
end
