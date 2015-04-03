class AddMissingIndexesLatest < ActiveRecord::Migration
	def change
		add_index :votes, :votable_id
		add_index :users, [:invited_by_id, :invited_by_type]
	end
end
