class CreateHelpArticles < ActiveRecord::Migration
  def change
    create_table :help_articles do |t|
      t.string :title
      t.text :body
      t.string :slug, null: false
      t.boolean :published, default: true
      t.integer :category_id, index: true

      t.timestamps null: false
    end
    add_index :help_articles, :slug, unique: true
  end
end
