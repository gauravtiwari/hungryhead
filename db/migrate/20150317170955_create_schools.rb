class CreateSchools < ActiveRecord::Migration

  disable_ddl_transaction!

  def change
    create_table :schools do |t|

      t.string :email, :null => false, default: ""

      t.uuid :uuid, null: false, default: 'uuid_generate_v4()'

      t.string :domain, :null => false, default: ""

      t.string :name, :null => false, unique: true

      t.text :description

      t.string :logo
      t.string :cover

      t.string :slug, :null => false, unique: true

      t.string :phone, :null => false, default: ""

      t.string :website_url, :null => false, default: ""

      t.string :facebook_url, :null => false, default: ""

      t.string :twitter_url, :null => false, default: ""

      t.jsonb :media, default: "{}"

      t.string :cached_location_list

      t.jsonb :customizations, default: "{}"

      t.timestamps null: false

    end

    add_index :schools, :user_id, algorithm: :concurrently
    add_index :schools, :name, unique: true, algorithm: :concurrently
    add_index :schools, :slug, unique: true, algorithm: :concurrently
    add_index :schools, :email, unique: true, algorithm: :concurrently

  end

end
