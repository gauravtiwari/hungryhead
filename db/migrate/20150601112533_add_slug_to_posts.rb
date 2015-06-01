class AddSlugToPosts < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    add_column :posts, :slug, :string, null: false
    add_index :posts, :slug, unique: true, algorithm: :concurrently
  end
end
