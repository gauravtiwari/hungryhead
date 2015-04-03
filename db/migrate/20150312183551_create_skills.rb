class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.string :name
      t.string :slug
      t.text :description

      t.timestamps null: false
    end
    add_index :skills, :slug, unique: true
  end
end
