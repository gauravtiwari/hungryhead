class CreateEvents < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    create_table :events do |t|
      t.string :title, null: false, default: ""
      t.belongs_to :eventable, null: false, default: "", polymorphic: true
      t.text :description, null: false, default: ""
      t.string :cover, null: false, default: ""
      t.string :slug, null: false, default: ""
      t.text :address
      t.integer :status, index: true, default: 1, null: false
      t.boolean :private, default: true
      t.datetime :start_time, null: false, default: DateTime.now
      t.datetime :end_time, null: false, default: DateTime.now
      t.float  :latitude, null: false, default: 0.0
      t.float  :longitude, null: false, default: 0.0
      t.timestamps null: false
    end

    add_index :events, [:eventable_id, :eventable_type], algorithm: :concurrently
    add_index :events, :start_time, algorithm: :concurrently
    add_index :events, :slug, algorithm: :concurrently
    add_index :events, [:latitude, :longitude], algorithm: :concurrently
    add_index :events, :private, algorithm: :concurrently
    add_index :events, :end_time, algorithm: :concurrently
  end
end
