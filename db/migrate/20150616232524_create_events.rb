class CreateEvents < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    create_table :events do |t|
      t.belongs_to :owner, null: false, default: "", polymorphic: true
      t.string :title, null: false, default: ""
      t.text :excerpt, null: false, default: ""
      t.text :description, null: false, default: ""
      t.uuid :uuid, null: false, default: 'uuid_generate_v4()'
      t.boolean :featured, index: true
      t.string :cached_category_list
      t.string :cover, null: false, default: ""
      t.string :slug, null: false, default: ""
      t.text :address, index: true
      t.boolean :private, default: true
      t.integer :space, default: 0
      t.jsonb  :media, :default => "{}"
      t.datetime :start_time
      t.datetime :end_time
      t.float  :latitude, null: false, default: 0.0
      t.float  :longitude, null: false, default: 0.0
      t.timestamps null: false
    end

    add_index :events, [:owner_id, :owner_type], algorithm: :concurrently
    add_index :events, :start_time, algorithm: :concurrently
    add_index :events, :slug, algorithm: :concurrently
    add_index :events, [:latitude, :longitude], algorithm: :concurrently
    add_index :events, :private, algorithm: :concurrently
    add_index :events, :end_time, algorithm: :concurrently
  end
end
