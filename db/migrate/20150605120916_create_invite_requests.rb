class CreateInviteRequests < ActiveRecord::Migration
  def change
    create_table :invite_requests do |t|
      t.string :name, null: false, default: ""
      t.string :email, null: false, default: ""
      t.string :url, null: false, default: ""
      t.string :type, default: "Mentor"
      t.timestamps null: false
    end
    add_index :invite_requests, :type
  end
end
