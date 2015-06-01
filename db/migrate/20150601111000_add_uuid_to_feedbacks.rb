class AddUuidToFeedbacks < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    add_column :feedbacks, :uuid, :uuid, null: false, default: 'uuid_generate_v4()'
    add_index :feedbacks, :uuid,  unique: true, algorithm: :concurrently
  end
end
