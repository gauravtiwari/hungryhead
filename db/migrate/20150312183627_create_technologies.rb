class CreateTechnologies < ActiveRecord::Migration
  def change
    create_table :technologies do |t|
      t.string :name
      t.string :slug
      t.text :description

      t.timestamps null: false
    end
    add_index :technologies, :slug, unique: true
  end
end
