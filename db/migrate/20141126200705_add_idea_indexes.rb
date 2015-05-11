class AddIdeaIndexes < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    add_index :investments, :user_id, algorithm: :concurrently
    add_index :investments, :idea_id, algorithm: :concurrently
  end
end
