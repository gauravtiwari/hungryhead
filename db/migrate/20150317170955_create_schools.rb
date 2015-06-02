class CreateSchools < ActiveRecord::Migration

  disable_ddl_transaction!

  def change
    create_table :schools do |t|

      t.string :email, :null => false, default: ""
      t.string :name, :null => false, unique: true

      t.string :slug, :null => false, unique: true

      t.text :description

      t.string :logo
      t.string :cover

      t.jsonb :media, default: "{}"
      t.jsonb :data, default: "{}"

      t.jsonb :customizations, default: "{}"

      t.timestamps null: false

    end

    add_index :schools, :name, unique: true, algorithm: :concurrently
    add_index :schools, :slug, unique: true, algorithm: :concurrently
    add_index :schools, :email, unique: true, algorithm: :concurrently

  end

end
