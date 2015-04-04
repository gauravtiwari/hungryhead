class AddCountToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :users_count, :integer, default: 0
    add_column :organizations, :ideas_count, :integer, default: 0
    add_column :organizations, :followers_count, :integer, default: 0
  end
end
