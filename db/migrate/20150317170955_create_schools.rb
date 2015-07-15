class CreateSchools < ActiveRecord::Migration

  disable_ddl_transaction!

  def change
    create_table :schools do |t|

      t.string :email, :null => false, default: ""

      t.string :domain, :null => false, default: ""

      t.string :name, :null => false, unique: true

      t.string :username, :null => false, unique: true

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

      t.string :encrypted_password, :null => false, :default => ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0, :null => false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Lockable
      t.integer  :failed_attempts, :default => 0, :null => false # Only if lock strategy is :failed_attempts
      t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at

      t.timestamps null: false

    end

    add_index :schools, :name, unique: true, algorithm: :concurrently
    add_index :schools, :slug, unique: true, algorithm: :concurrently
    add_index :schools, :email, unique: true, algorithm: :concurrently
    add_index :schools, :reset_password_token, :unique => true, algorithm: :concurrently
    add_index :schools, :unlock_token, :unique => true, algorithm: :concurrently
    add_index :schools, :username, unique: true, algorithm: :concurrently

  end

end
