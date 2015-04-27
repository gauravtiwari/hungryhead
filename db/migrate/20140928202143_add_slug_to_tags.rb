class AddSlugToTags < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    add_column :tags, :slug, :string
    add_index :tags, :slug, algorithm: :concurrently
  end
end
