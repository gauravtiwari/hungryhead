class AddMissingIndexesLatest < ActiveRecord::Migration
  disable_ddl_transaction!
	def change
		add_index :votes, :votable_id, algorithm: :concurrently
		add_index :users, [:invited_by_id, :invited_by_type], algorithm: :concurrently
	end
end
