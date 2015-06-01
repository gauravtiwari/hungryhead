class AddUuidToPosts < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    add_column :posts, :uuid, :uuid, null: false, default: 'uuid_generate_v4()'
    add_index :posts, :uuid,  unique: true, algorithm: :concurrently
  end
end
