class AddCountToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :users_count, :integer, default: 0
    add_column :schools, :ideas_count, :integer, default: 0
    add_column :schools, :followers_count, :integer, default: 0
  end
end
