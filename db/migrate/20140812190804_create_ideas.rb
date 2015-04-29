class CreateIdeas < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    create_table :ideas do |t|

      t.integer :student_id, :null => false

      t.string :name
      t.string :slug, :unique => true

      t.string :high_concept_pitch, default: ""
      t.text :elevator_pitch, default: ""
      t.text :description, default: ""

      t.string :logo
      t.string :cover

      t.string :team_ids, array: true, default: "{}"
      t.string :team_invites_ids, array: true, default: "{}"

      t.boolean :looking_for_team, default: false

      t.integer :school_id

      t.integer :status, default: 0
      t.integer :privacy, default: 0

      t.boolean :rules_accepted, index: true, default: false

      t.jsonb :settings, default: "{}"
      t.jsonb  :media, :default => "{}"
      t.jsonb :profile, default: "{}"
      t.jsonb :sections, default: "{}"
      t.jsonb :fund, default: "{}"

      t.string :cached_location_list
      t.string :cached_market_list
      t.string :cached_technology_list

      t.timestamps null: false
    end

    add_index :ideas, :school_id, algorithm: :concurrently
    add_index :ideas, :student_id, algorithm: :concurrently
    add_index :ideas, :status, algorithm: :concurrently
    add_index :ideas, :privacy, algorithm: :concurrently
    add_index :ideas, :slug, algorithm: :concurrently
    add_index :ideas, :looking_for_team, algorithm: :concurrently
  end
end
