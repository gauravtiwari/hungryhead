class AddSharesCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :shares_count, :integer
  end
end
