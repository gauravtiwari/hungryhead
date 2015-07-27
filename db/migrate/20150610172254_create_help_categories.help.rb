# This migration comes from help (originally 20150608203724)
class CreateHelpCategories < ActiveRecord::Migration
  def change
    create_table :help_categories do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.string :slug, null: false

      t.timestamps null: false
    end
    add_index :help_categories, :slug, unique: true
  end
end
