class AddUuidToFeedbacks < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    add_column :feedbacks, :uuid, :string, null: false, default:  SecureRandom.hex(6)
    add_index :feedbacks, :uuid,  unique: true, algorithm: :concurrently
  end
end
