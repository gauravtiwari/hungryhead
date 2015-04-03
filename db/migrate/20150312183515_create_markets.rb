class CreateMarkets < ActiveRecord::Migration
  def change
    create_table :markets do |t|
      t.string :name
      t.string :slug
      t.text :description

      t.timestamps null: false
    end
    add_index :markets, :slug, unique: true
  end
end
