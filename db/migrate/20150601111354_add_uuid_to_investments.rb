class AddUuidToInvestments < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    add_column :investments, :uuid, :uuid, null: false,  default: 'uuid_generate_v4()'
    add_index :investments, :uuid, unique: true, algorithm: :concurrently
  end
end
