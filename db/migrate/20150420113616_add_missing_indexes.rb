class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :slugs, [:sluggable_id, :sluggable_type]
    add_index :taggings, [:tag_id]
    add_index :merit_activity_logs, :action_id
    add_index :follows, [:followable_id, :followable_type]
    add_index :follows, [:follower_id, :follower_type]
    add_index :comments, :parent_id
    add_index :votes, [:votable_id, :votable_type]
    add_index :votes, [:voter_id, :voter_type]
  end
end