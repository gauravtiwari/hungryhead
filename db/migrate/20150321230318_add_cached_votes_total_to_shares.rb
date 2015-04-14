class AddCachedVotesTotalToShares < ActiveRecord::Migration
  def change
    add_column :shares, :cached_votes_total, :integer, default: 0
  end
end
