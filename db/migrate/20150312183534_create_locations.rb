class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.string :slug
      t.text :description

      t.timestamps null: false
    end
    add_index :locations, :slug, unique: true
  end
end
