class AddSessionsTable < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    create_table :sessions do |t|
      t.string :session_id, :null => false
      t.text :data
      t.timestamps null: false
    end

    add_index :sessions, :session_id, :unique => true, algorithm: :concurrently
    add_index :sessions, :updated_at, algorithm: :concurrently
  end
end
