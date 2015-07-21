class CreateInviteRequests < ActiveRecord::Migration
  def change
    create_table :invite_requests do |t|
      t.string :name, null: false, default: ""
      t.string :email, null: false, default: ""
      t.string :url, null: false, default: ""
      t.integer :user_type, default: 1
      t.timestamps null: false
    end
    add_index :invite_requests, :type
    add_index :invite_requests, :email, unique: true
  end
end
