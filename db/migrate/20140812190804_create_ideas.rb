class CreateIdeas < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    create_table :ideas do |t|

      t.references :user, :null => false

      t.uuid :uuid, null: false, default: 'uuid_generate_v4()'

      t.string :name, null: false, :unique => true

      t.string :slug, :unique => true, null: false, default: ""

      t.string :high_concept_pitch, default: "", null: false

      t.text :elevator_pitch, default: "", null: false

      t.text :description, default: ""
      t.string :video
      t.text :video_html
      t.text :market
      t.text :problems
      t.text :solutions
      t.text :vision
      t.text :value_proposition
      t.text :business_model
      t.string :logo
      t.string :cover

      t.string :team_ids, array: true, default: "{}"
      t.string :team_invites_ids, array: true, default: "{}"

      t.boolean :looking_for_team, default: false

      t.references :school

      t.integer :status, default: 0
      t.integer :privacy, default: 0

      t.boolean :investable, default: false

      t.boolean :validated, null: false, default: false

      t.boolean :rules_accepted, index: true, default: false

      t.jsonb :settings, default: "{}"
      t.jsonb  :media, :default => "{}"
      t.jsonb :profile, default: "{}"

      t.jsonb :fund, default: "{}"

      t.string :cached_location_list
      t.string :cached_market_list
      t.string :cached_technology_list

      t.timestamps null: false
    end

    add_index :ideas, :school_id, algorithm: :concurrently
    add_index :ideas, :user_id, algorithm: :concurrently

    #Add index for school with status and privacy
    add_index :ideas, [:school_id, :validated], algorithm: :concurrently
    add_index :ideas, [:status, :privacy], algorithm: :concurrently
    add_index :ideas, [:status, :privacy, :school_id], algorithm: :concurrently

    add_index :ideas, [:user_id, :validated], algorithm: :concurrently
    add_index :ideas, [:status, :privacy, :user_id], algorithm: :concurrently

    #Index team ids
    add_index :ideas, :team_ids, using: :gin, algorithm: :concurrently

    #Add partial indexes for idea
    add_index :ideas, :investable, name: "index_idea_investable", where: "investable IS TRUE", algorithm: :concurrently
    add_index :ideas, :validated, name: "index_idea_validated", where: "validated IS TRUE", algorithm: :concurrently
    add_index :ideas, :looking_for_team, name: "index_idea_looking_for_team", where: "looking_for_team IS TRUE", algorithm: :concurrently

    add_index :ideas, :slug, algorithm: :concurrently
  end
end
