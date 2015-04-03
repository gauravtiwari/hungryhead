class CreateSlugs < ActiveRecord::Migration
  def change
    create_table :slugs do |t|
      t.string   :slug,           :null => false
      t.belongs_to :sluggable, polymorphic: true, index: true
      t.string   :scope
      t.timestamps null: false
    end
    add_index :slugs, :sluggable_id
    add_index :slugs, [:slug, :sluggable_type, :scope], :unique => true
  end
end
