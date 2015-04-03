class AddNotesCountToIdeas < ActiveRecord::Migration
  def change
    add_column :ideas, :notes_count, :integer, default: 0
    add_index :ideas, :notes_count
  end
end
