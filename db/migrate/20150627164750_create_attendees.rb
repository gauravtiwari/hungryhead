class CreateAttendees < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    create_table :attendees do |t|
      t.references :attendee, class_name: 'User', foreign_key: true, null: false
      t.references :event, foreign_key: true, null: false
      t.integer :status, null: false, default: 1

      t.timestamps null: false
    end

    add_index :attendees, :attendee_id, algorithm: :concurrently
    add_index :attendees, :event_id, algorithm: :concurrently
    add_index :attendees, [:attendee_id, :event_id], unique: true, algorithm: :concurrently
  end
end
