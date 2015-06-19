class CreateSlugs < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    create_table :slugs do |t|
      t.string   :slug,           :null => false
      t.belongs_to :sluggable, polymorphic: true, index: true, null: false
      t.string   :scope
      t.timestamps null: false
    end
    add_index :slugs, :sluggable_id, algorithm: :concurrently
    add_index :slugs, [:sluggable_id, :sluggable_type, :slug], unique: true
    add_index :slugs, :slug,  algorithm: :concurrently
  end
end
