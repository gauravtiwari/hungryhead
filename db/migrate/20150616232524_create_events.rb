class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title, null: false, default: ""
      t.references :user, null: false, default: ""
      t.string :description, null: false, default: ""
      t.string :location, null: false, default: ""
      t.datetime :start_time, null: false, default: DateTime.now
      t.datetime :end_time, null: false, default: DateTime.now
      t.boolean :guest_invites, default: false

      t.timestamps null: false
    end

    add_index :events, :user_id, algorithm: :concurrently
    add_index :events, :start_time, algorithm: :concurrently
    add_index :events, :end_time, algorithm: :concurrently
  end
end
