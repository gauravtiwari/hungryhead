class CreateEvents < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    create_table :events do |t|
      t.string :title, null: false, default: ""
      t.belongs_to :eventable, null: false, default: "", polymorphic: true
      t.string :description, null: false, default: ""
      t.string :cover, null: false, default: ""
      t.string :cached_location_list
      t.datetime :start_time, null: false, default: DateTime.now
      t.datetime :end_time, null: false, default: DateTime.now
      t.boolean :guest_invites, default: false
      t.boolean :private, default: true

      t.timestamps null: false
    end

    add_index :events, [:eventable_id, :eventable_type], algorithm: :concurrently
    add_index :events, :start_time, algorithm: :concurrently
    add_index :events, :private, algorithm: :concurrently
    add_index :events, :end_time, algorithm: :concurrently
  end
end
