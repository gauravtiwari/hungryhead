class AddIdeaIndexes < ActiveRecord::Migration
  def change
    add_index :investments, :user_id
    add_index :investments, :idea_id
    add_index :feedbacks, :sash_id
    add_index :ideas, :sash_id
  end
end
