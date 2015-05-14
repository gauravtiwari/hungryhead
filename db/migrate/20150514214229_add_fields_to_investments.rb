class AddFieldsToInvestments < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    add_column :investments, :sash_id, :integer
    add_column :investments, :level,   :integer, :default => 0
    add_index :posts, :sash_id, algorithm: :concurrently
    add_index :posts, :level, algorithm: :concurrently
  end
end
