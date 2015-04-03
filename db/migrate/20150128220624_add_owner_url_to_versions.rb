class AddOwnerUrlToVersions < ActiveRecord::Migration
  def change
    add_column :versions, :owner_url, :string
  end
end
