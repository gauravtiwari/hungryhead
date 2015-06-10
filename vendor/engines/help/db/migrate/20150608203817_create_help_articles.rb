class CreateHelpArticles < ActiveRecord::Migration
  def change
    create_table :help_articles do |t|
      t.string :title
      t.text :body
      t.string :slug, null: false
      t.references :category, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :help_articles, :slug, unique: true
  end
end
