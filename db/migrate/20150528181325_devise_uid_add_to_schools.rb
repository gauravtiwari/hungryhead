class DeviseUidAddToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :uid, :string
    add_index :schools, :uid, :unique => true
  end
end
