class AddUuidToInvestments < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    add_column :investments, :uuid, :string, null: false,  default: SecureRandom.hex(6)
    add_index :investments, :uuid, unique: true, algorithm: :concurrently
  end
end
