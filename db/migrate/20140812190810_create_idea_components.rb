class CreateIdeaComponents < ActiveRecord::Migration
  def change
    create_table :idea_components do |t|
      t.string :title
      t.string :help_text
      t.text :body
      t.references :idea
      t.integer :privacy
      t.integer :position

      t.timestamps null: false
    end
    add_index :idea_components, :idea_id
    add_index :idea_components, [:idea_id, :privacy]
    add_index :idea_components, :position
    add_index :idea_components, :privacy
  end
end
