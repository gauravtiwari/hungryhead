class CreateEventInvites < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    create_table :event_invites do |t|
      t.references :invited, index: true, class_name: 'User'
      t.references :inviter, polymorphic: true, index: true
      t.references :event, index: true, foreign_key: true
      t.timestamps null: false
    end

    add_index :event_invites, [:inviter_id, :inviter_type, :invited_id, :event_id], name: 'unique_event_invites', unique: true, algorithm: :concurrently
  end
end
