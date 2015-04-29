class CreateInvestments < ActiveRecord::Migration
  def change
    create_table :investments do |t|
      t.integer :amount, :null => false
      t.string :note, :null => false
      t.integer :user_id, :null => false
      t.integer :idea_id, :null => false
      t.jsonb :parameters, default: "{}"

      #Caching ids
      t.string :voters_ids, array: true, default: "{}"
      t.string :commenters_ids, array: true, default: "{}"

      t.integer :votes_count, null: false, default: 0
      t.integer :comments_count, null: false, default: 0
      t.timestamps null: false
    end
  end
end
