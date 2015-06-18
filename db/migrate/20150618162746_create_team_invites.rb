class CreateTeamInvites < ActiveRecord::Migration
  def change
    create_table :team_invites do |t|
      t.belongs_to :inviter, index: true, class_name: 'User'
      t.belongs_to :invited, index: true, class_name: 'User'
      t.references :idea, index: true, foreign_key: true
      t.text :msg
      t.string :token

      t.timestamps null: false
    end
    add_index :team_invites, :token
  end
end
