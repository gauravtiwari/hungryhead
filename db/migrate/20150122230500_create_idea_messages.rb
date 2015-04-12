class CreateIdeaMessages < ActiveRecord::Migration
  def change
    create_table :idea_messages do |t|
      t.belongs_to :user, index: true, :null => false
      t.belongs_to :idea, index: true, :null => false
      t.text :body, :null => false
      t.integer :status
      t.timestamps null: false
    end
    add_foreign_key :idea_messages, :users
    add_foreign_key :idea_messages, :ideas
  end
end
