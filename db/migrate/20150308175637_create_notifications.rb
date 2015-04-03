class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :reciever_id
      t.integer :sender_id
      t.jsonb :parameters
      t.timestamps null: false
    end
    add_index :notifications, :sender_id
    add_index :notifications, :reciever_id
  end
end
