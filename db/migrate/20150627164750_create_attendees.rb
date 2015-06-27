class CreateAttendees < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    create_table :attendees do |t|
      t.references :attendee, class_name: 'User', null: false
      t.references :event, null: false
      t.integer :status, null: false, default: 1

      t.timestamps null: false
    end

    add_index :events, :attendee_id, algorithm: :concurrently
    add_index :events, :event_id, algorithm: :concurrently
    add_index :events, [:attendee_id, :event_id], unique: true, algorithm: :concurrently
  end
end
