class AddSlugToInvestments < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    add_column :investments, :slug, :string, null: false, default: ""
    add_index :investments, :slug, unique: true, algorithm: :concurrently
  end
end
