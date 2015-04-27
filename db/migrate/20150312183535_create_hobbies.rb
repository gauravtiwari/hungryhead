class CreateHobbies < ActiveRecord::Migration
  def change
    create_table :hobbies do |t|
      t.string :name
      t.string :slug
      t.text :description
      t.timestamps null: false
    end
    add_index :hobbies, :slug, unique: true
  end
end
