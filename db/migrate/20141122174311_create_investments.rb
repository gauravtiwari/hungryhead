class CreateInvestments < ActiveRecord::Migration
  def change
    create_table :investments do |t|
      t.integer :amount, :null => false
      t.string :note, :null => false
      t.integer :user_id, :null => false
      t.integer :idea_id, :null => false
      t.integer :comments_count,default: 0, index: true
      t.integer :cached_votes_total, default: 0, index: true
      t.jsonb :parameters, default: "{}"
      t.timestamps null: false
    end
    add_index :investments, :parameters, using: :gin
  end
end
