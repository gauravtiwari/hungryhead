class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
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
      t.timestamps null: false
    end
    add_index :organizations, :name, unique: true
    add_index :organizations, :slug, unique: true
    add_index :organizations, :email, unique: true
    add_index :organizations, :type
    add_index :organizations, :data, using: :gin
  end
end
