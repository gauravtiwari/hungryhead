class CreateMeta < ActiveRecord::Migration
  def change
    create_table :meta do |t|
 	  t.string :name
      t.string :slug, index: true, :unique => true
      t.string :high_concept_pitch, default: ""
      t.text :elevator_pitch, default: ""
      t.text :description, default: ""
      t.string :logo
      t.string :cover
      t.string :founders, array: true, default: "{}"
      t.boolean :looking_for_team, index: true, default: false
      t.jsonb :profile, default: "{}"
      t.jsonb :sections, default: "{}"
      t.string :cached_location_list
      t.string :cached_market_list
      t.string :cached_technology_list
      t.integer :followers_count, default: 0, index: true
      t.integer :comments_count,default: 0, index: true
      t.integer :cached_votes_total, default: 0, index: true
      t.integer :user_id, :null => false, index: true
      t.timestamps null: false
    end
  end
end
