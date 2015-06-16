class CreateImpressions < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    create_table :impressions do |t|
      t.references :impressionable, polymorphic: true, null: false
      t.string :ip_address, null: false
      t.integer :user_id, null: false
      t.string :controller_name
      t.string :action_name
      t.string :referrer
      t.timestamps null: false
    end
    add_index :impressions, :impressionable_type, algorithm: :concurrently
    add_index :impressions, :impressionable_id, algorithm: :concurrently
    add_index :impressions, :ip_address, algorithm: :concurrently
    add_index :impressions, :user_id, algorithm: :concurrently
  end
end
