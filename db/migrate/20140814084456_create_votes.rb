class CreateVotes < ActiveRecord::Migration
  disable_ddl_transaction!
  def self.up
    create_table :votes do |t|
      t.references :votable, :polymorphic => true, null: false
      t.integer :voter_id, class_name: 'User', foreign_key: true, null: false
      t.boolean :vote_flag, default: true
      t.string :vote_scope
      t.integer :vote_weight
      t.timestamps null: false
    end

    add_index :votes, :voter_id, algorithm: :concurrently
    add_index :votes, [:votable_id, :votable_type, :voter_id], algorithm: :concurrently, unique: true
  end

  def self.down
    drop_table :votes
  end
end
