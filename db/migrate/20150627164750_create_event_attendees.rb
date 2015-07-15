class CreateEventAttendees < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    create_table :event_attendees do |t|
      t.references :attendee, class_name: 'User', null: false
      t.references :event, foreign_key: true, null: false
      t.timestamps null: false
    end

    add_index :event_attendees, :attendee_id, algorithm: :concurrently
    add_index :event_attendees, :event_id, algorithm: :concurrently
    add_index :event_attendees, [:attendee_id, :event_id], unique: true, algorithm: :concurrently
  end
end
