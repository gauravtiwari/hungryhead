class CreateSchools < ActiveRecord::Migration
   def change
    create_table :schools do |t|
      t.string :email, :null => false, default: ""
      t.string :name, :null => false, unique: true
      t.string :slug, :null => false, unique: true
      t.text :description
      t.string :logo
      t.string :type
      t.string :cover
      t.jsonb :media, default: "{}"
      t.jsonb :data, default: "{}"
      t.jsonb :customizations, default: "{}"
      t.integer :users_count, default: 0, index: true
      t.integer :ideas_count, default: 0, index: true
      t.integer :followers_count, default: 0, index: true
      t.timestamps null: false
    end
    add_index :schools, :name, unique: true
    add_index :schools, :slug, unique: true
    add_index :schools, :email, unique: true
    add_index :schools, :type
    add_index :schools, :data, using: :gin
  end
end
