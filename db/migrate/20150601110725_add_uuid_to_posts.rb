class AddUuidToPosts < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    add_column :posts, :uuid, :string, null: false, default: SecureRandom.hex(6)
    add_index :posts, :uuid,  unique: true, algorithm: :concurrently
  end
end
