class CreateTeamInvites < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    create_table :team_invites do |t|
      t.belongs_to :inviter, index: true, class_name: 'User'
      t.belongs_to :invited, index: true, class_name: 'User'
      t.references :idea, index: true, foreign_key: true
      t.text :msg
      t.boolean :pending, null: false, default: true
      t.string :token

      t.timestamps null: false
    end
    add_index :team_invites, [:inviter_id, :invited_id, :idea_id], unique: true, algorithm: :concurrently
    add_index :team_invites, :token, algorithm: :concurrently
  end
end
