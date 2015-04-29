class DeviseCreateUsers < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    create_table(:users) do |t|
      ## Database authenticatable
      t.string :email, :null => false
      t.string :first_name, null: false, :default => ""
      t.string :last_name, null: false, :default => ""
      t.string :name, null: false, :default => ""
      t.string :username, null: false
      t.string :avatar, :default => ""
      t.string :type, :default => "User", index: true
      t.string :cover, :default => ""
      t.string :slug
      t.string :mini_bio, default: ""
      t.text :about_me, :default => ""
      t.jsonb  :profile, :default => "{}"
      t.jsonb  :interests, :default => "{}"
      t.jsonb  :media, :default => "{}"
      t.jsonb  :settings, :default => "{}"
      t.jsonb  :fund, :default => "{}"
      t.integer :school_id
      t.string :cached_location_list
      t.string :cached_market_list
      t.string :cached_skill_list
      t.string :cached_subject_list
      t.string :cached_technology_list
      t.string :cached_service_list
      t.integer :ideas_count, null: false, default: 0
      t.integer :followers_count, null: false, default: 0
      t.integer :followings_count, null: false, default: 0
      t.integer :comments_count, null: false, default: 0
      t.integer :investments_count, null: false, default: 0
      t.integer :feedbacks_count, null: false, default: 0
      t.boolean :verified, default: false
      t.boolean :admin, default: false
      t.boolean :terms_accepted, default: false
      t.boolean :rules_accepted, default: false
      t.integer :role, default: 0, index: true
      t.integer :state, default: 0, index: true
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

      ## Confirmable
       t.string   :confirmation_token
       t.datetime :confirmed_at
       t.datetime :confirmation_sent_at
       t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, :default => 0, :null => false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at
      t.timestamps null: false
    end
    add_index :users, :school_id, algorithm: :concurrently
    add_index :users, :email,                :unique => true, algorithm: :concurrently
    add_index :users, :slug,                :unique => true, algorithm: :concurrently
    add_index :users, :reset_password_token, :unique => true, algorithm: :concurrently
    add_index :users, :confirmation_token,   :unique => true, algorithm: :concurrently
    # add_index :users, :unlock_token,         :unique => true
  end
end
