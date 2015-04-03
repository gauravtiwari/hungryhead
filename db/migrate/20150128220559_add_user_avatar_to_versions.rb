class AddUserAvatarToVersions < ActiveRecord::Migration
  def change
    add_column :versions, :user_avatar, :string
  end
end
