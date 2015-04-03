class CreateIdeas < ActiveRecord::Migration
  def change
    create_table :ideas do |t|
      t.string :name
      t.string :slug, index: true, :unique => true
      t.string :high_concept_pitch, default: ""
      t.text :elevator_pitch, default: ""
      t.text :description, default: ""
      t.string :logo
      t.string :cover
      t.string :team, array: true, default: "{}"
      t.string :team_invites, array: true, default: "{}"
      t.string :feedbackers, array: true, default: "{}"
      t.string :investors, array: true, default: "{}"
      t.boolean :looking_for_team, index: true, default: false
      t.integer :institution_id, index: true
      t.integer :status, index: true, default: 0
      t.integer :privacy, index: true, default: 0
      t.jsonb :settings, default: "{}"
      t.jsonb  :media, :default => "{}"
      t.jsonb :profile, default: "{}"
      t.jsonb :sections, default: "{}"
      t.jsonb :fund, default: "{}"
      t.string :cached_location_list
      t.string :cached_market_list
      t.string :cached_technology_list
      t.integer :investments_count, default: 0, index: true
      t.integer :idea_problems_count, default: 0
      t.integer :idea_solutions_count, default: 0
      t.integer :idea_customers_count, default: 0
      t.integer :idea_competitors_count, default: 0
      t.integer :idea_value_propositions_count, default: 0
      t.integer :feedbacks_count, default: 0, index: true
      t.integer :followers_count, default: 0, index: true
      t.integer :comments_count,default: 0, index: true
      t.integer :cached_votes_total, default: 0, index: true
      t.integer :idea_messages_count,  default: 0, index: true
      t.integer :user_id, :null => false, index: true
      t.timestamps null: false
    end
    add_index :ideas, :profile, using: :gin
    add_index :ideas, :settings, using: :gin
    add_index :ideas, :fund, using: :gin
  end
end
