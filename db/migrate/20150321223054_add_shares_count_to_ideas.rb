class AddSharesCountToIdeas < ActiveRecord::Migration
  def change
    add_column :ideas, :shares_count, :integer, default: 0
    add_index :ideas, :shares_count
  end
end
