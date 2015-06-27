class CreateAttendees < ActiveRecord::Migration
  def change
    create_table :attendees do |t|
      t.integer :attendee_id
      t.integer :event_id
      t.integer :status

      t.timestamps null: false
    end
  end
end
